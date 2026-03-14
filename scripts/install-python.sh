#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 25 April 2025
# Updated : 12 March 2026 (Ubuntu 24.04 LTS compatibility - Python 2 removed)
# Purpose : Installs Python 2 (or Python 3 fallback on Ubuntu 24.04+)
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

# Install Python 3 (available on all supported versions).
et-log "Installing Python 3..."
apt install \
  python3 \
  python3-setuptools \
  python3-pip \
  -y

# Also install Python 2 where available (Ubuntu 22.10 Kinetic).
# On Ubuntu 24.04 (Noble), python2 is no longer in the repos.
if apt-cache show python2 &>/dev/null; then
  et-log "Installing Python 2..."
  apt install \
    python2 \
    python-setuptools \
    -y
  update-alternatives --install /usr/bin/python python /usr/bin/python2 2
  update-alternatives --install /usr/bin/python python /usr/bin/python3 1
else
  et-log "Python 2 not available, setting python3 as default..."
  update-alternatives --install /usr/bin/python python /usr/bin/python3 1
fi
