#!/bin/bash
# Check stock level for an item
# Usage: ./check-stock.sh <sku>

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <sku>" >&2
  exit 1
fi

: "${INVENTORY_API_URL:?INVENTORY_API_URL environment variable is required}"
: "${INVENTORY_API_KEY:?INVENTORY_API_KEY environment variable is required}"

curl -s "${INVENTORY_API_URL}/items/$1" \
  -H "Authorization: Bearer ${INVENTORY_API_KEY}" | jq '.'
