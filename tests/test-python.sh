#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 November 2025
# Updated  : 12 March 2026 (accept Python 3 on Ubuntu 24.04)
# Purpose  : Test Python installation

# Check for python (2.7 on Kinetic, or 3.x on Noble via update-alternatives).
# Fall back to python3 if the python symlink was not created.
python --version 2>&1 | grep -qE "2\.|3\." && exit 0
python3 --version 2>&1 | grep -q "3\." && exit 0
exit 1
