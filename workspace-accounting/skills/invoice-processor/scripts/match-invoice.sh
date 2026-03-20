#!/bin/bash
# Match an invoice to a purchase order
# Usage: ./match-invoice.sh <invoice_id> <po_number>

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <invoice_id> <po_number>" >&2
  exit 1
fi

INVOICE_ID="$1"
PO_NUMBER="$2"

: "${FINANCE_API_URL:?FINANCE_API_URL environment variable is required}"
: "${FINANCE_API_KEY:?FINANCE_API_KEY environment variable is required}"

curl -s -X POST "${FINANCE_API_URL}/invoices/match" \
  -H "Authorization: Bearer ${FINANCE_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"invoice_id\": \"${INVOICE_ID}\",
    \"po_number\": \"${PO_NUMBER}\"
  }" \
  | jq '.'
