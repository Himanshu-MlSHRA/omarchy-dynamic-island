#!/bin/bash
# Installs and enables the OSD companion, so volume and brightness show inside
# the island. Omarchy only finds a plugin at the top of its plugins folder, so
# this one is copied there. Enabling it disables the stock omarchy.osd, and
# `omarchy plugin remove` on it brings the stock one back.
set -euo pipefail

id=io.github.himanshu-mlshra.dynamic-island-osd
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
target="$HOME/.config/omarchy/plugins/$id"

mkdir -p "$target"
cp "$here/manifest.json" "$here/Osd.qml" "$target/"

omarchy-shell shell rescanPlugins >/dev/null
for _ in {1..20}; do
  omarchy plugin list 2>/dev/null | grep -q "^$id " && break
  sleep 0.25
done
omarchy plugin enable "$id"
# The island only takes over the osd IPC target on a fresh start.
omarchy restart shell
