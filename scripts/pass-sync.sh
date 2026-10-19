#!/usr/bin/env bash
# One-way sync of Bitwarden -> local pass store.
#
# Every Login item in the Bitwarden folder is written to pass under the same name
# as the item, so an item called "personal/github/tokens/foo" is read with
# `pass show personal/github/tokens/foo`. Edit secrets in Bitwarden, never
# in pass. Items deleted in Bitwarden are NOT removed from pass.
#
# Prompts for the Bitwarden master password (and 2FA on first login), so it needs a
# terminal. Needs: bw, jq, pass.
#
# usage: pass-sync.sh [folder=pass]
set -euo pipefail

FOLDER="${1:-pass}"

for cmd in bw jq pass; do
    command -v "$cmd" &>/dev/null || { echo "pass-sync: $cmd not found" >&2; exit 1; }
done

if ! bw login --check &>/dev/null; then
    bw login
fi

SESSION=$(bw unlock --raw)
trap 'bw lock &>/dev/null || true' EXIT

bw sync --session "$SESSION" >/dev/null

FOLDER_ID=$(bw list folders --session "$SESSION" </dev/null \
    | jq -r --arg f "$FOLDER" '.[] | select(.name == $f) | .id')
if [[ -z "$FOLDER_ID" ]]; then
    echo "pass-sync: no Bitwarden folder named '$FOLDER'" >&2
    exit 1
fi

count=0
skipped=0
while IFS=$'\t' read -r id name; do
    # Item names are free text — keep them inside the pass store
    if [[ "$name" == /* || "$name" == *..* ]]; then
        echo "pass-sync: skipping '$name' (unsafe path)" >&2
        skipped=$((skipped + 1))
        continue
    fi
    # Password goes through a pipe so it never shows up in process arguments
    bw get password "$id" --session "$SESSION" </dev/null | pass insert -e -f "$name" >/dev/null
    echo "  synced $name"
    count=$((count + 1))
done < <(bw list items --folderid "$FOLDER_ID" --session "$SESSION" </dev/null \
    | jq -r '.[] | select(.type == 1 and .login.password != null) | "\(.id)\t\(.name)"')

echo "pass-sync: $count synced, $skipped skipped"
