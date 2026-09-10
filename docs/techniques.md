# Techniques

This page explains how mojo-yaml encodes and decodes. It is a description of
the shipped code. Each section names the problem, why this library uses a
given method, and what you give up by using it.

The library is written in Mojo. It does not call libyaml, libfyaml, RapidYAML
(ryml), yaml-cpp, serde_yaml, or goccy/go-yaml. The methods below are ports
of ideas from those libraries and from the sibling
[serializer-benchmark](https://github.com/leo-gan/GLD.SerializerBenchmark)
clients (C `libyaml`, C++ `yaml-cpp`, Python PyYAML, Go `goccy/go-yaml`,
JavaScript `js-yaml`, Rust `serde_yaml`).

The timed path is a generated struct (`YamlDatum`) with `encode_into` and
`decode`. `YamlValue` (the dynamic tree) is not that path.

Numbers on this page come from the local `benches/microbench.mojo` on this
host. They are useful for a compile-test loop. They are not an official
cross-language ranking. There is no Mojo YAML row in serializer-benchmark
yet.

On the generated `Message` record, a 2026-09-10 local pass moved decode
from about **4739 ns to about 2477 ns** (about 48% less time) and encode
from about **327 ns to about 260 ns**. The decode change is expected-order
field reads, in-place int/bool parse, a fast `try_key`, and skipping
`take_alias` when the document has no anchors. The encode change is
skipping the `encoded_len` pre-walk and writing depth-0 field separators
as one `"\nkey: "` literal.

## Two paths

A **generated struct** is a Mojo type that the CLI `gld-yamlgen-mojo`
writes from a JSON Schema. It has three methods:

| Method | Role |
| --- | --- |
| `encoded_len` | How many bytes the value will occupy |
| `encode_to` | Write those bytes into a `WireWriter` |
| `decode_from` | Read those bytes from a `WireReader` |

Object keys are known at generate time. The encoder writes them as constants.
The decoder expects the same key order that this library writes. Extra keys
are skipped. Missing required keys are an error.

**Problem this solves.** A general decoder does not know the next field. It
must read a key, look it up, then read a value. That lookup is a hash map or
a long `if` chain, and the key is often a heap `String`. A generated decoder
already knows the schema, so it can compare the next bytes to `"f_bool"` and
move on.

**Trade-off.** If another program writes the same fields in a different
order, the fast path fails and a slower generic loop runs. The text is still
accepted. You pay the fast-path probe, then the generic walk.

`YamlValue` is an **arena**: one list of nodes, plus side lists for strings
and binary payloads. It can hold any well-formed Core document without a
schema. It allocates more. It is the right tool for unknown data. It is not
the speed target.

## Encode

Encode means “turn a Mojo value into YAML text.”

### Pre-sized buffer

`WireWriter` holds a `List[Byte]` and a cursor `pos`. A store writes
`buf[pos]` and adds one to `pos`.

**Problem.** If the list’s length starts at 0, every store may grow the list.
Growing copies the old bytes to a larger allocation.

**What we do.** `encode` calls `encoded_len` first, then constructs the
writer with that length plus a small pad. `encode_into` reuses a caller list
so a loop of encodes does not allocate a new list each time. That is the same
idea as ryml emit-into-buffer and Go `goccy/go-yaml` `Encoder`.

**Trade-off.** `encoded_len` walks the value twice. For a small `Message`
that extra walk is cheap next to an allocation.

### Baked keys and 2-space indent

Generated encode writes `f_bool: ` as a constant byte run. Indent is a
constant run of spaces when `indent` is 2, not a loop of one space per
column.

**Problem.** Building `"f_bool: "` with string concatenation on every field
allocates. Writing indent with one `write_byte(' ')` per space is a tight
loop the CPU already has a better answer for (a store of two spaces).

**Trade-off.** Changing the public indent width still works. The two-space
fast path is the default.

### Compact sequence-of-mapping

A sequence of mappings is written as `- sku: a` then `qty` aligned with
`sku`. That is PyYAML’s usual `safe_dump` layout and the layout
`encoded_len_at` counts.

**Trade-off.** A nested form (`-\n    sku:`) is also legal YAML. This library
does not emit it, so owned goldens are this compact form only.

## Decode

Decode means “turn YAML text into a Mojo value.”

### Indent-aware collection API

JSON can `eat('{')`. YAML block mappings have no braces. Generated
`decode_from` calls `begin_map` / `next_key` / `try_key` / `begin_seq` /
`next_item`. Start-of-line spaces are indent, not whitespace to discard.
`gld-json` `skip_ws_span` is not copied.

**Problem.** If the reader skipped every space the way a JSON reader does, a
tab in indent would be silent and a dedent would be invisible.

**Trade-off.** The reader is larger than a JSON reader. Flow `{…}` / `[…]`
still uses the same methods with a `CTX_FLOW` flag.

### Expected-order keys

`try_key` compares the next key’s UTF-8 to a baked literal. A 4- or 8-byte
key uses a little-endian word load. A miss leaves `pos` unchanged and the
generic loop runs.

**Source.** ryml’s expected-key helpers; sibling `gld-json` / `gld-messagepack`
expected-order decode; glaze-style typed skip.

### SIMD / SWAR scan

`wire/simdscan.mojo` walks the input with native SIMD width. It finds the
next `#`, quote, or line break without a per-byte loop when a full vector
remains.

**Source.** ryml in-place scan; simdjson / EmberJson `pack_bits` +
`count_trailing_zeros`; sibling `gld-json` `simdscan.mojo`.

**Trade-off.** The tail shorter than one vector is scalar. That is required
for correctness. We do not mutate the caller `Span[Byte]` (ryml in-situ).
Unescape copies into an owned `String` only when an escape is present.

### Reserved indent stack

Nesting depth is a reserved `List[Int]`, not a heap frame per level.

**Source.** ryml arena tree; libfyaml’s explicit indent stack.

### Comment skip

After content, a SIMD run that is “not `#` and not newline” advances to the
comment or the break. Start-of-line spaces stay for `line_indent`.

## Ideas researched and not used in v1

| Idea | Where it is fast | Why v1 does not do it |
| --- | --- | --- |
| In-situ parse (overwrite the buffer) | ryml | Public API takes an immutable `Span[Byte]` |
| Event SAX then tree | libyaml | Extra allocations; ryml’s own reason to exist |
| Pointer node graph | yaml-cpp | Cache misses; this library uses an arena |
| YAML 1.1 implicit bools | PyYAML | Core-schema product lock |
| Link libyaml / ryml | C/C++ clients | From-scratch rule |

## Local microbench

`benches/microbench.mojo` times `encode_into` and `decode` of the generated
`Message` record. It prints nanoseconds per operation. It does not fail CI
on a ratio. It does not import EmberJson, PyYAML, or serializer-benchmark.
