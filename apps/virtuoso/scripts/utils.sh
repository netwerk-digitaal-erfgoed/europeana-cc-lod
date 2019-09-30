#!/bin/bash

set -e

function printError() {
    echo $'\e[1;31m'$*$'\e[0m' >>/dev/stderr
}

function printProgress() {
    echo $'\e[1;32m'$*$'\e[0m' >>/dev/stderr
}

function checkArgAndExitOnError() {
    if [ -z "$2" ]; then
        printError "Error: missing argument: $1"
        printError "Usage: $0 --$1 {$1}"
        exit 1
    fi
}

function checkEnvAndExitOnError() {
    if [ -z "$2" ]; then
        printError "Error: missing environment variable $1"
        exit 1
    fi
}
