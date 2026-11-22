#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 VENV_PATH" >&2
    exit 1
fi

LOCATION=$(mktemp -d)
trap 'rm -rf "$LOCATION"' EXIT

git clone --filter=blob:none https://gitlab.com/fdroid/fdroidserver.git --recursive "$LOCATION"

# Get new tags from remote
git -C "$LOCATION" fetch --tags

# Get latest tag name
LATEST_TAG=$(git -C "$LOCATION" describe --tags "$(git -C "$LOCATION" rev-list --tags --max-count=1)")

# Checkout latest tag
git -C "$LOCATION" checkout "$LATEST_TAG"

python3 -m venv "$1"
"$1/bin/python" -m pip install "$LOCATION"
