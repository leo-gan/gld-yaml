# mojo-yaml

mojo-yaml is a [YAML 1.2](https://yaml.org/spec/1.2.2/) serializer written in
[Mojo](https://www.modular.com/mojo). The runtime and the code generator are
Mojo. They do not wrap libyaml or any other C, C++, or Rust YAML library.

<div class="grid cards" markdown="1">

-   __Why YAML__

    ---

    What YAML 1.2 Core is, how block and flow collections work, how implicit
    types differ from YAML 1.1, and how anchors fit.

    [:octicons-arrow-right-24: Read Why YAML](why-yaml.md)

-   __Instructions__

    ---

    Install Mojo 1.0.0 with pixi, write a JSON Schema, generate Mojo, run the
    tests, and publish this site.

    [:octicons-arrow-right-24: Open Instructions](instructions.md)

-   __Examples__

    ---

    Encode and decode generated types, `YamlValue`, and multi-document
    streams.

    [:octicons-arrow-right-24: See Examples](examples.md)

-   __Techniques__

    ---

    How encode and decode work: pre-sized writes, indent stack, SIMD scan,
    expected-order keys, and which ideas were measured and kept.

    [:octicons-arrow-right-24: Read Techniques](techniques.md)

-   __Test data__

    ---

    What lives under `testdata/` (schemas, oracle text, fail-path goldens)
    and why each file is there.

    [:octicons-arrow-right-24: Read Test data](test-data.md)

</div>
