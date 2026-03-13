#!/bin/bash
#
# Author   : Gaston Gonzalez
# Date     : 21 November 2022
# Updated  : 12 March 2026 (Ubuntu 24.04 LTS compatibility - protect desktop and network)
# Purpose  : Remove unwanted packages

et-log "Removing unwanted packages"

# Safe to remove on all versions
apt purge \
  libreoffice-\* \
  thunderbird \
  unattended-upgrades \
  update-manager \
  update-notifier \
  -y

# On Ubuntu 24.04 (Noble), snapd is deeply integrated with the GNOME desktop.
# Removing it causes apt autoremove to cascade-remove GNOME Shell components
# and network-manager-gnome, which kills the desktop environment entirely.
# We skip snapd removal on 24.04+ to preserve system integrity.
UBUNTU_CODENAME=$(lsb_release -cs 2>/dev/null || echo "unknown")
if [ "${UBUNTU_CODENAME}" == "kinetic" ]; then
  et-log "Kinetic detected - removing snapd..."
  apt purge snapd -y
else
  et-log "Ubuntu ${UBUNTU_CODENAME} detected - keeping snapd to protect desktop."
fi

# Use autoremove with explicit protection for critical desktop and network packages
# to prevent cascading removal of components we need.
apt autoremove \
  --no-remove \
  2>/dev/null || \
apt-get autoremove -y \
  --no-remove-essential
