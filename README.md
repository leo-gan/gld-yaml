# mojo-yaml

A from-scratch [YAML 1.2](https://yaml.org/spec/1.2.2/) implementation for
[Mojo](https://mojolang.org/). The runtime and the code generator are written
in Mojo. They do not wrap, link, or vendor libyaml, RapidYAML, yaml-cpp, or
any other C, C++, or Rust YAML library.

Python PyYAML is a **test oracle** for semantic equality on Core-schema-safe
values. It is not required to encode or decode at runtime.

This repository is a standalone library. It is not part of any other project.

Documentation: [leo-gan.github.io/gld-yaml](https://leo-gan.github.io/gld-yaml/).
That site has a YAML format overview, the install steps, schema walkthrough,
examples, encode/decode techniques, and test-data notes.

## Install

Published package (linux-64) on [prefix.dev/leo-gan/leo-gan](https://prefix.dev/leo-gan/leo-gan):

```bash
pixi add --channel https://prefix.dev/leo-gan/leo-gan mojo-yaml
```

## Develop

```bash
git clone https://github.com/leo-gan/gld-yaml.git
cd gld-yaml
pixi install
pixi run test
```

If `pixi install` fails with 401 on `conda.modular.com`, set `PREFIX_API_KEY`
in a local `.env` (never commit that file) and run `scripts/ci-setup.sh`.

## License

MIT. Copyright (c) 2026 Leonid Ganeline.
