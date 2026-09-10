# Golden files

`scripts/gen_golden.py` owns the atom and small-collection files. Fail-path
`tab_indent.yaml` is a literal (a tab cannot come from a legal encode).

Each `.yaml` has a sibling `.hex` of the same bytes. Owned encode goldens
end with exactly one `LF`.
