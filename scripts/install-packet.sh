#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 27 March 2023
# Updated : 3 January 2025
# Updated : 12 March 2026 (Ubuntu 24.04 - prevent NetworkManager disruption from AX.25)
# Purpose : Install packet packages
set -e

et-log "Installing AX.25 packages..."
apt install \
  ax25-tools \
  ax25-apps \
  expect \
  -y

# On Ubuntu 24.04, loading the AX.25 kernel module triggers a NetworkManager
# rescan that can temporarily drop the active connection. We tell NetworkManager
# to ignore AX.25 interfaces (ax0, ax1, ...) before loading the module so the
# rescan does not affect the existing network connection.
if [ -d /etc/NetworkManager/conf.d ]; then
  et-log "Configuring NetworkManager to ignore AX.25 interfaces..."
  cat > /etc/NetworkManager/conf.d/99-ax25-unmanaged.conf << 'EOF'
[keyfile]
unmanaged-devices=interface-name:ax*
EOF
  systemctl reload NetworkManager 2>/dev/null || true
fi

et-log "Installing rfcomm sudoers rules..."
cp -v ../overlay/etc/sudoers.d/* /etc/sudoers.d/

et-log "Updating AX.25 port permissions..."
chgrp -v -R $ET_GROUP /etc/ax25/axports
chmod -v 664 /etc/ax25/axports

