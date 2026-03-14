#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 April 2025
# Updated  : 12 March 2026 (handle Python 3 install path differences on Ubuntu 24.04)
# Purpose  : Test mb-util installation

# On Python 2, setup.py installs mb-util to /usr/local/bin.
# On Python 3 (Ubuntu 24.04), it may land in /usr/local/bin or ~/.local/bin.
# Check both which and known fallback paths.
if which mb-util &>/dev/null; then
  exit 0
elif [ -f /usr/local/bin/mb-util ]; then
  exit 0
elif python3 -c "import mbutil" &>/dev/null 2>&1; then
  exit 0
else
  exit 1
fi
