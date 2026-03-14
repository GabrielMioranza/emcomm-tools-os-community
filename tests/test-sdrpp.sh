#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 1 December 2025
# Updated  : 12 March 2026 (handle Jammy .deb install path on Ubuntu 24.04)
# Purpose  : Test SDR++ installation

# The SDR++ nightly .deb targets Ubuntu Jammy (22.04). On Noble (24.04)
# the binary installs correctly but may be in /usr/bin instead of /usr/local/bin.
if which sdrpp &>/dev/null; then
  exit 0
elif [ -f /usr/bin/sdrpp ]; then
  exit 0
elif [ -f /usr/local/bin/sdrpp ]; then
  exit 0
else
  exit 1
fi
