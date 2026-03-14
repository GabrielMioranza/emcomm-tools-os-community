#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 3 November 2024
# Updated  : 12 March 2026 (accept Java 21 on Ubuntu 24.04)
# Purpose  : Test Java installation

# We need to redirect stderr to stdout otherwise grep will not match.
# Java 20 is used on Ubuntu 22.10 (Kinetic); Java 21 is used on Ubuntu 24.04 (Noble).
JAVA_OUT=$(java -version 2>&1 | grep -E "20\.|21\.")
exit $?
