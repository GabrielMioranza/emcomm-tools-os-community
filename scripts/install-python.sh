#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 25 April 2025
# Updated : 12 March 2026 (Ubuntu 24.04 LTS compatibility - Python 2 removed)
# Purpose : Installs Python 2 (or Python 3 fallback on Ubuntu 24.04+)
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

# Python 2 is not available in Ubuntu 24.04 (Noble). Use Python 3 instead.
if apt-cache show python2 &>/dev/null; then
  et-log "Installing Python 2..."
  apt install \
    python2 \
    python-setuptools \
    -y
  # Set Python 2 as the default only if explicitly on a supported older release
  update-alternatives --install /usr/bin/python python /usr/bin/python2 1
else
  et-log "Python 2 not available (Ubuntu 24.04+). Installing Python 3..."
  apt install \
    python3 \
    python3-setuptools \
    python3-pip \
    -y
  # Ensure 'python' command points to python3
  if ! command -v python &>/dev/null; then
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1
  fi
fi
