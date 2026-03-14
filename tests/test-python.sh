#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 25 November 2025
# Updated  : 12 March 2026 (accept Python 3 on Ubuntu 24.04)
# Purpose  : Test Python installation

# Python 2.7 is used on Ubuntu 22.10 (Kinetic).
# Python 3.x is used on Ubuntu 24.04 (Noble) since Python 2 is not in the repos.
OUT=$(python --version 2>&1 | grep -E "2\.7|3\.")
exit $?
