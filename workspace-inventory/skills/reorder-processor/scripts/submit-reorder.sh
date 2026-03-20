#!/bin/bash
# Submit a reorder request
# Usage: ./submit-reorder.sh <sku> <quantity> <supplier_id>

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <sku> <quantity> <supplier_id>" >&2
  exit 1
fi

SKU="$1"; QTY="$2"; SUPPLIER="$3"

: "${INVENTORY_API_URL:?INVENTORY_API_URL environment variable is required}"
: "${INVENTORY_API_KEY:?INVENTORY_API_KEY environment variable is required}"

curl -s -X POST "${INVENTORY_API_URL}/reorders" \
  -H "Authorization: Bearer ${INVENTORY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"sku\":\"${SKU}\",\"quantity\":${QTY},\"supplier_id\":\"${SUPPLIER}\"}" \
  | jq '.'
