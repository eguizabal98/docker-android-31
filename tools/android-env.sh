#!/usr/bin/env bash

# Set Android SDK environment variables
export ANDROID_HOME="/opt/android-sdk-linux"
export ANDROID_SDK_ROOT="${ANDROID_HOME}"
export ANDROID_SDK_HOME="${ANDROID_HOME}"
export ANDROID_SDK="${ANDROID_HOME}"

# Update system PATH to include Android SDK tools
export PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
export PATH="${PATH}:${ANDROID_HOME}/build-tools/34.0.0"
export PATH="${PATH}:${ANDROID_HOME}/platform-tools"
export PATH="${PATH}:${ANDROID_HOME}/emulator"

# Function to print welcome message
function print_header() {
    figlet "Android SDK"
    figlet "Environment"
    echo ''
}

# Function to display available commands
function help() {
    figlet "Usage:"
    echo "update_sdk: Updates the Android SDK"
    echo "andep: Installs one or more Android SDK packages."
    echo "   Example: andep \"platforms;android-34\""
    echo "help: Shows this help"
    echo ''
}

# Function to update Android SDK and accept licenses
function update_sdk() {
    sdkmanager --licenses && sdkmanager --update
}

# Function to install specific Android SDK packages
function andep() {
    if [ -z "$1" ]; then
        help
        return 1
    fi
    sdkmanager "$1"
}

# Export functions to be used in the shell session
export -f help
export -f update_sdk
export -f andep
