#!/bin/sh
# Export cura version to env - extracted from the /download/<version>/ segment of the URL
export CURRENT_CURA_VERSION=$(sed 's|.*/download/\([^/]*\)/.*|\1|' /app/download_url)
# Extract major_minor part to use as folder name (strips patch: 5.12.1 → 5.12, 5.16 → 5.16)
CURRENT_CURA_VERSION_MAJOR_MINOR=$(echo $CURRENT_CURA_VERSION | cut -d'.' -f1,2)
# Print current version
echo "current cura version: $CURRENT_CURA_VERSION"
echo "current cura major_minor version: $CURRENT_CURA_VERSION_MAJOR_MINOR"
# Rename previous versions folders to match current version, to keep settings and plugins (stupid cura)
if [ ! $(find /config/xdg/data/cura -maxdepth 0 -empty) ]; then
    mv /config/xdg/data/cura/* /config/xdg/data/cura/$CURRENT_CURA_VERSION_MAJOR_MINOR
    echo 
fi
if [ ! $(find /config/xdg/config/cura -maxdepth 0 -empty) ]; then
    mv /config/xdg/config/cura/* /config/xdg/config/cura/$CURRENT_CURA_VERSION_MAJOR_MINOR
fi
# Start openbox
openbox &
# Run obxprop after a delay
(
    sleep 10
    #   obxprop > /tmp/obxprop_output.txt # Debugging step, to get an window's properties with crosshair
) &
# Execute the AppRun from the extracted AppImage directory with platformtheme option
/app/squashfs-root/AppRun -platformtheme gtk3
