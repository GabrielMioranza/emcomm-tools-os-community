#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 1 December 2025
# Updated  : 12 March 2026 (handle Jammy .deb install path on Ubuntu 24.04)
# Purpose  : Test SDR++ installation

# Check for sdrpp binary via which, then via dpkg as fallback since the
# Jammy .deb may install to a path not covered by the current PATH.
which sdrpp 2>/dev/null && exit 0
dpkg -s sdrpp 2>/dev/null | grep -q "Status: install ok installed" && exit 0
exit 1
