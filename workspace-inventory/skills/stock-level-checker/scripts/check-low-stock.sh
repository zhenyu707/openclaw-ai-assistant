#!/bin/bash
# Check all items below reorder point
# Usage: ./check-low-stock.sh

set -euo pipefail

: "${INVENTORY_API_URL:?INVENTORY_API_URL environment variable is required}"
: "${INVENTORY_API_KEY:?INVENTORY_API_KEY environment variable is required}"

curl -s "${INVENTORY_API_URL}/items?below_reorder=true" \
  -H "Authorization: Bearer ${INVENTORY_API_KEY}" | jq '.'
