#!/bin/sh
set -euo pipefail

echo connection established to $(cat /etc/hostname)
while true; do
    sleep 30
done
