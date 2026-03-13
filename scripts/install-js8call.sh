#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 6 April 2023
# Updated : 24 October 2024
# Updated : 12 March 2026 (Ubuntu 24.04 LTS compatibility - Qt5 t64 packages)
# Purpose : Install JS8Call
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

VERSION="2.2.0"
FILE="js8call_${VERSION}_20.04_amd64.deb"
URL="http://files.js8call.com/${VERSION}/${FILE}"

et-log "Installing JS8Call dependencies..."

# Ubuntu 24.04 (Noble) renamed many Qt5 packages with a t64 suffix due to
# the 64-bit time_t migration. We detect which variant is available and
# install accordingly. libqt5multimediagsttools5 was dropped in 24.04.

install_qt5_pkg() {
  local pkg=$1
  if apt-cache show "${pkg}t64" &>/dev/null; then
    apt install "${pkg}t64" -y
  elif apt-cache show "${pkg}" &>/dev/null; then
    apt install "${pkg}" -y
  else
    et-log "Warning: ${pkg} (and t64 variant) not found, skipping."
  fi
}

for pkg in \
  libqt5serialport5 \
  libqt5widgets5 \
  libqt5multimediawidgets5 \
  libqt5core5a \
  libqt5gui5 \
  libqt5multimedia5 \
  libqt5network5 \
  libqt5printsupport5 \
  libqt5dbus5 \
  libqt5svg5; do
  install_qt5_pkg "$pkg"
done

# Packages that kept their name or are handled separately
apt install \
  libqt5multimedia5-plugins \
  libdouble-conversion3 \
  libpcre2-16-0 \
  qttranslations5-l10n \
  libmd4c0 \
  libxcb-xinerama0 \
  libxcb-xinput0 \
  qt5-gtk-platformtheme \
  libgfortran5 \
  -y || apt-get -f install -y

# libqt5multimediagsttools5 was removed in Ubuntu 24.04 (merged into Qt5 multimedia)
if apt-cache show libqt5multimediagsttools5 &>/dev/null; then
  apt install libqt5multimediagsttools5 -y
else
  et-log "libqt5multimediagsttools5 not available (Ubuntu 24.04+), skipping."
fi

if [ ! -e $ET_DIST_DIR/$FILE ]; then
  et-log "Downloading JS8Call: $URL"

  curl -s -L -O --fail $URL

  [ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR

  mv -v $FILE $ET_DIST_DIR
else
  et-log "${FILE} already downloaded. Skipping..."
fi

# Use --force-depends because the .deb targets Ubuntu 20.04 and some
# dependency names changed in 24.04 (t64 migration)
dpkg -i --force-depends $ET_DIST_DIR/$FILE || apt-get -f install -y

et-log "Updating JS8Call launcher icon to support PNP..."
cp -v ../overlay/usr/share/applications/js8call.desktop /usr/share/applications/
