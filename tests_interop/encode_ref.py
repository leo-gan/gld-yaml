#!/usr/bin/env python3
"""PyYAML oracle encoder. Core-schema-safe values only."""
from __future__ import annotations

import sys

import yaml


def main() -> None:
    data = yaml.safe_load(sys.stdin)
    sys.stdout.write(yaml.safe_dump(data, sort_keys=False))


if __name__ == "__main__":
    main()
