#!/bin/sh

if [ -z "$CONFIG_KEYALIAS" ]; then
    echo 'ERROR: Missing $CONFIG_KEYALIAS environment variable'
    exit 1
fi

if [ -z "$CONFIG_KEYPASS" ]; then
    echo 'ERROR: Missing $CONFIG_KEYPASS environment variable'
    exit 1
fi

if [ -z "$CONFIG_KEYSTORE_PASS" ]; then
    echo 'ERROR: Missing $CONFIG_KEYSTORE_PASS environment variable'
    exit 1
fi

if [ -z "$CONFIG_KEYDNAME" ]; then
    echo 'ERROR: Missing $CONFIG_KEYDNAME environment variable'
    exit 1
fi

if [ -z "$KEYSTORE" ]; then
    echo 'ERROR: Missing $KEYSTORE environment variable'
    exit 1
fi

[ ! -d "repo" ] && mkdir -p "repo"

replace_placeholder() {
    sed -i "s/$1/$(echo "$2" | sed -e "s/\&/\\\&/")/g" config.yml
}

replace_placeholder KEYALIAS      "$CONFIG_KEYALIAS"
replace_placeholder KEYPASS       "$CONFIG_KEYPASS"
replace_placeholder KEYSTORE_PASS "$CONFIG_KEYSTORE_PASS"
replace_placeholder KEYDNAME      "$CONFIG_KEYDNAME"

chmod 600 config.yml

echo "$KEYSTORE" | base64 -d - > keystore.p12

fdroid build --no-tarball --all
fdroid publish
fdroid update --pretty --delete-unknown --use-date-from-apk

# Cleanup secrets
rm -r keystore.p12 config.yml
