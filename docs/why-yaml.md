# Why YAML

[YAML](https://yaml.org/spec/1.2.2/) is a text format. A decoder can walk a
document without a schema. Block collections use indentation. Flow collections
use `[…]` and `{…}` the way JSON does. Comments start with `#`.

A schema language is optional. This library uses a [JSON Schema](https://json-schema.org/)
subset, plus a closed list of YAML extras, to generate Mojo structs.
Schema-free work uses `YamlValue`.

This library implements **YAML 1.2 Core**. It does not implement YAML 1.1
implicit typing. `yes`, `no`, `on`, `off`, and `NO` are strings, not booleans.
Python PyYAML is a test oracle only, and it is YAML 1.1 by default, so interop
tests use Core-schema-safe values only.

The rest of this page is the subset of the spec that the library implements.
[Instructions](instructions.md) shows how to install and generate code.
[Examples](examples.md) shows the matching Mojo calls.

## Core implicit types

Plain scalars are typed by this table. Quoted scalars stay strings.

| Plain text | Core type |
| --- | --- |
| `null`, `Null`, `NULL`, `~`, empty | null |
| `true` / `True` / `TRUE` / `false` / `False` / `FALSE` | bool |
| decimal, `0o…`, `0x…` | int |
| decimal with `.` or exponent, `.inf`, `-.inf`, `.nan` | float |
| anything else | string |

## Collections

A block mapping is keys at one indent, each followed by `:`. A block sequence
is lines that start with `- `. A sequence of mappings is compact: the first
key sits on the same line as `-`, and the later keys line up with that first
key.

Flow collections are `{key: value}` and `[a, b]`.

## Anchors

`&name` marks a node. `*name` repeats it. Default encode expands aliases. A
cycle cannot be expanded and is an error unless `keep_anchors` is set.

## Tags

Core tags `!!null`, `!!bool`, `!!int`, `!!float`, `!!str`, `!!seq`, and
`!!map` are accepted. `!!binary` is a v1 extra (base64). Every `%TAG`
directive is an error. `%YAML 1.2` is ignored.
