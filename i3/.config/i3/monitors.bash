#!/bin/bash

# Detect current screen configuration
autorandr --change > /dev/null 2>&1

# Get primary and secondary monitor names
read -r primary secondary < <(xrandr --listmonitors | tail -n +2 | awk '{if ($2 ~ /\+\*/) print $NF; else print $NF}' | paste -sd' ')

# If no secondary detected, default to primary
if [[ -z "$secondary" ]]; then
  secondary="$primary"
fi

sed -i \
  -e "s/^set \$primaryMonitor.*/set \$primaryMonitor $primary/" \
  -e "s/^set \$secondaryMonitor.*/set \$secondaryMonitor $secondary/" \
  ~/.config/i3/monitors.conf


current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

i3-msg "workspace 1; move workspace to output $primary"
i3-msg "workspace 2; move workspace to output $primary"
i3-msg "workspace 3; move workspace to output $primary"
i3-msg "workspace 4; move workspace to output $primary"

i3-msg "workspace 6; move workspace to output $secondary"
i3-msg "workspace 7; move workspace to output $secondary"
i3-msg "workspace 8; move workspace to output $secondary"
i3-msg "workspace 9; move workspace to output $secondary"

i3-msg "workspace $current_workspace"

