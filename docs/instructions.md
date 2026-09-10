# Instructions

## Install the published package

```bash
pixi add --channel https://prefix.dev/leo-gan/leo-gan mojo-yaml
```

The package is `linux-64` only. It installs `yaml.mojoc` and the
`gld-yamlgen-mojo` CLI.

## Develop from git

```bash
git clone https://github.com/leo-gan/gld-yaml.git
cd gld-yaml
pixi install
pixi run test
```

`pixi.toml` pins `mojo == 1.0.0`. If `pixi install` fails with 401 on
`conda.modular.com`, put `PREFIX_API_KEY` in a local `.env` (never commit
that file) and run `scripts/ci-setup.sh`.

## Generate types

Write a JSON Schema document. The accepted keywords are the same subset as
`gld-messagepack`: `type`, `properties`, `required`, `items`, `$ref`,
`$defs`, `enum`, `const`, `oneOf` / `anyOf` for unions. YAML extras are
`x-yaml-style`, `x-yaml-binary`, and `x-yaml-plain`.

```bash
pixi run generate
# or
mojo run -I src src/codegen/cli.mojo -- --schema testdata/schema/benchmark_v2.json --out tests/generated
```

Generated structs import `from yaml import …`. Compile them with `-I src`.

## Tasks

| Task | Command |
| --- | --- |
| Tests | `pixi run test` |
| Goldens | `pixi run golden` |
| Generate | `pixi run generate` |
| Precompile | `pixi run precompile` |
| Check generated | `pixi run check-generated` |
| Microbench | `pixi run --feature bench microbench` |

## Docs site

```bash
pip install -r requirements-docs.txt
mkdocs serve
mkdocs build --strict
```
