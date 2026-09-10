#!/usr/bin/env bash
# Semantic interop with PyYAML on Core-schema-safe values.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
python3 tests_interop/encode_ref.py <<'EOF' >/tmp/gld-yaml-ref.yaml
true
EOF
python3 tests_interop/decode_ref.py </tmp/gld-yaml-ref.yaml
echo "interop oracle ok"
