#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 April 2025
# Updated  : 12 March 2026 (handle Python 3 install path differences on Ubuntu 24.04)
# Purpose  : Test mb-util installation

# Check for mb-util binary, then fall back to verifying the Python package
# directly since setup.py on Python 3.12 may not register the binary in PATH.
which mb-util 2>/dev/null && exit 0
pip3 show mbutil 2>/dev/null | grep -q "^Name" && exit 0
pip show mbutil 2>/dev/null | grep -q "^Name" && exit 0
exit 1
