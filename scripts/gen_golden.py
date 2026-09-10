#!/usr/bin/env python3
"""Write testdata/golden/*.yaml and *.hex. Owned encode goldens, plus fail literals."""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GOLDEN = ROOT / "testdata" / "golden"


def write_text(name: str, data: str) -> None:
    GOLDEN.mkdir(parents=True, exist_ok=True)
    raw = data.encode("utf-8")
    (GOLDEN / f"{name}.yaml").write_bytes(raw)
    (GOLDEN / f"{name}.yaml.hex").write_text(raw.hex() + "\n", encoding="utf-8")


def main() -> None:
    write_text("null", "null\n")
    write_text("true", "true\n")
    write_text("false", "false\n")
    write_text("int_0", "0\n")
    write_text("int_150", "150\n")
    write_text("int_neg1", "-1\n")
    write_text("text_hi", "hi\n")
    write_text("array_1_2", "- 1\n- 2\n")
    write_text("object_a_1", "a: 1\n")
    write_text("tab_indent", "a:\n\tb: 1\n")


if __name__ == "__main__":
    main()
