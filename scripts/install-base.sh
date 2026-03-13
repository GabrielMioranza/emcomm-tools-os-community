#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 16 March 2024
# Updated : 28 February 2025
# Updated : 12 March 2026 (Ubuntu 24.04 LTS compatibility)
# Purpose : Install base tools and configuration
set -e

et-log "Installing environment variables..."
cp -v ../overlay/etc/environment /etc/

et-log "Installing message of the day..."
cp -v ../overlay/etc/motd /etc/

et-log "Installing base packages..."

# Detect Ubuntu version to select correct JDK
UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null || echo "0")
if dpkg -l openjdk-21-jdk &>/dev/null || apt-cache show openjdk-21-jdk &>/dev/null; then
  JDK_PACKAGE="openjdk-21-jdk"
else
  JDK_PACKAGE="openjdk-20-jdk"
fi
et-log "Using JDK package: ${JDK_PACKAGE}"

apt install \
  build-essential \
  cmake \
  curl \
  gpg \
  imagemagick \
  jq \
  net-tools \
  ${JDK_PACKAGE} \
  openssh-server \
  screen \
  socat \
  stow \
  xsel \
  tree \
  -y

# steghide is not available in Ubuntu 24.04 repos; install only if available
if apt-cache show steghide &>/dev/null; then
  apt install steghide -y
else
  et-log "steghide not available in this Ubuntu version, skipping."
fi
