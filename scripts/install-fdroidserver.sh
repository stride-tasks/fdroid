#!/bin/sh

# Create temporary directory for repository
LOCATION=$(mktemp -d)

git clone --filter=blob:none https://gitlab.com/fdroid/fdroidserver.git --recursive "$LOCATION"

# Get new tags from remote
git -C "$LOCATION" fetch --tags

# Get latest tag name
LATEST_TAG=$(git -C "$LOCATION" describe --tags "$(git -C "$LOCATION" rev-list --tags --max-count=1)")

# Checkout latest tag
git -C "$LOCATION" checkout $LATEST_TAG

# Install fdroidserver
sudo pip install -e "$LOCATION"
