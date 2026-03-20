#!/bin/bash
# Get vendor information
# Usage: ./get-vendor.sh <vendor_id>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <vendor_id>" >&2
  exit 1
fi

: "${OPS_API_URL:?OPS_API_URL environment variable is required}"
: "${OPS_API_KEY:?OPS_API_KEY environment variable is required}"

curl -s "${OPS_API_URL}/vendors/$1" \
  -H "Authorization: Bearer ${OPS_API_KEY}" | jq '.'
