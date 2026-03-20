#!/bin/bash
# Get purchase order details
# Usage: ./get-order.sh [order_id]

set -euo pipefail

: "${INVENTORY_API_URL:?INVENTORY_API_URL environment variable is required}"
: "${INVENTORY_API_KEY:?INVENTORY_API_KEY environment variable is required}"

if [[ $# -ge 1 ]]; then
  curl -s "${INVENTORY_API_URL}/orders/$1" \
    -H "Authorization: Bearer ${INVENTORY_API_KEY}" | jq '.'
else
  curl -s "${INVENTORY_API_URL}/orders?status=active" \
    -H "Authorization: Bearer ${INVENTORY_API_KEY}" | jq '.'
fi
