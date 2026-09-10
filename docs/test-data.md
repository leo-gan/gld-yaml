# Test data

Files under `testdata/` are ordinary unit and interop material. They are not
a product schema and they are not a dependency on any other repository.

## `testdata/schema/`

JSON Schema documents for `gld-yamlgen-mojo`.

| File | Why it exists |
| --- | --- |
| `benchmark_v2.json` | Suite records `Message`, `Document`, `Telemetry`, `Strings`, `Event` |
| `longlist.json` | Recursive optional `next` so codegen emits `Box[LongList]` |
| `keywords.json` | Mojo reserved field names (`struct`, `fn`, `var`) |
| `union.json` | Tagged union of named objects |

## `testdata/golden/`

Owned encode goldens and fail-path literals. `scripts/gen_golden.py` writes
the atom files. Each `.yaml` has a sibling `.hex`.

| File | Why it exists |
| --- | --- |
| `true.yaml`, `null.yaml`, `0.yaml`, … | Byte-stable atoms; each ends with one `LF` |
| `array_1_2.yaml`, `object_a_1.yaml` | Small collections in this library’s block form |
| `tab_indent.yaml` | Fail path: tab in indent is `KIND_INDENT` |

PyYAML `safe_dump` is **not** the byte oracle. YAML has more than one legal
encoding. Interop checks semantic equality on Core-schema-safe values.

## Why Core-safe values

PyYAML is YAML 1.1 by default. `yes` and `NO` become booleans there. This
library is YAML 1.2 Core, so those plains are strings. Interop tests avoid
those tokens so a difference is a real bug, not a 1.1/1.2 split.
