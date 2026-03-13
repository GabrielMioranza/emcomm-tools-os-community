#!/bin/bash
#
# Author  : Gaston Gonzalez
# Date    : 16 March 2024
# Updated : 6 October 2024
# Updated : 12 March 2026 (Ubuntu 24.04 LTS compatibility - skip sources.list override)
# Purpose : Updates the apt repository to use the old-releases

et-log "Updating apt repositories..."

# The overlay sources.list points to Ubuntu Kinetic (22.10) old-releases.
# On Ubuntu 24.04 LTS (Noble) we must NOT overwrite sources.list or we
# would replace the Noble repos with Kinetic repos, breaking all package
# installation and potentially dropping the network connection mid-install.
UBUNTU_CODENAME=$(lsb_release -cs 2>/dev/null || echo "unknown")
if [ "${UBUNTU_CODENAME}" == "kinetic" ]; then
  et-log "Kinetic detected - switching to old-releases mirror..."
  cp -v ../overlay/etc/apt/sources.list /etc/apt/
else
  et-log "Ubuntu ${UBUNTU_CODENAME} detected - keeping existing sources.list."
fi

cp -v ../overlay/etc/crontab /etc/

apt update
