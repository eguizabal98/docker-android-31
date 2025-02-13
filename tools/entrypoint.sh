#!/bin/bash

# Function to check if su-exec is available
function checkbin() {
    type -P su-exec > /dev/null 2>&1
}

# Function to run commands as the android user
function su_mt_user() {
    su android -c '"$@"' -- "$@"
}

# Ensure the android-sdk-linux directory is owned by the android user
chown android:android /opt/android-sdk-linux

# Check if su-exec is available and use it for executing the script as android user
if checkbin; then
    exec su-exec android:android /opt/tools/android-sdk-update.sh "$@"
else
    su_mt_user /opt/tools/android-sdk-update.sh "$@"
fi
