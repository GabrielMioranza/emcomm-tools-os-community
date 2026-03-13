#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 1 October 2024
# Updated  : 4 October 2024
# Updated  : 12 March 2026 (Ubuntu 24.04 LTS compatibility)
# Purpose  : Navit installer for EmComm Tools
# Category : Maps
#
# The Navit package is broken in the Ubuntu repository. The following installation is based
# on a fixed reported in https://github.com/navit-gps/navit/issues/1228

# navit-gui-internal required for car display
# navit-graphics-gtk-drawing-area required for desktop display

# Install navit and available sub-packages; some split packages may not exist in 24.04
apt install \
  navit \
  navit-gui-gtk \
  navit-graphics-gtk-drawing-area \
  navit-gui-internal \
  maptool \
  espeak \
  osmium-tool \
  -y || true

# Repair any broken dependencies left by partial navit install
apt-get -f install -y

# libcanberra-gtk-dev was renamed in Ubuntu 24.04
if apt-cache show libcanberra-gtk-dev &>/dev/null; then
  apt install libcanberra-gtk-dev -y
elif apt-cache show libcanberra-gtk3-dev &>/dev/null; then
  apt install libcanberra-gtk3-dev -y
else
  et-log "libcanberra-gtk-dev not found, skipping."
fi
