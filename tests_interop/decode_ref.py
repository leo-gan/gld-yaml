#!/usr/bin/env python3
"""PyYAML oracle decoder. Prints a stable repr for semantic compare."""
from __future__ import annotations

import sys

import yaml


def main() -> None:
    data = yaml.safe_load(sys.stdin)
    print(repr(data))


if __name__ == "__main__":
    main()
