#!/usr/bin/env bash

if [ -z $1 ]; then
    echo "Package file not specific"
    echo "  install.sh RemoteDesktopManager.Free_X.X.X_amd64.deb"
    exit
fi

if [ -z "$(which dpkg-deb)" ]; then
	echo "You need dpkg-deb!"
    echo "  OpenSUSE: sudo zypper install dpkg"
	exit
fi

TMP_DIR="${1/.deb/}"

INSTALL_DIR="$HOME/.local/bin/RemoteDesktopManager.Free"

if [ -d "$INSTALL_DIR" ]; then
	echo "Removing previous installation dir - $INSTALL_DIR"
	rm -rf $INSTALL_DIR
fi

if [ -f "$HOME/.local/bin/remotedesktopmanager.free" ]; then
	echo "Removing previous cmdline launcher - $HOME/.local/bin/remotedesktopmanager.free"
	rm "$HOME/.local/bin/remotedesktopmanager.free"
fi

if [ -f "$HOME/.local/share/icons/remotedesktopmanager.free.png" ]; then
	echo "Removing previous icon - $HOME/.local/share/icons/remotedesktopmanager.free.png"
	rm $HOME/.local/share/icons/remotedesktopmanager.free.png
fi

echo "Extracting .deb archive to $TMP_DIR"
dpkg-deb -X $1 $TMP_DIR >/dev/null

echo "Moving installation dir to $HOME/.local/bin/"
mv ./$TMP_DIR/usr/lib/devolutions/RemoteDesktopManager.Free $HOME/.local/bin/

echo "Moving application icon to $HOME/.local/share/icons/"
mv ./$TMP_DIR/usr/share/icons/remotedesktopmanager.free.png $HOME/.local/share/icons/

echo "Creating substitute cmdline launcher $HOME/.local/bin/remotedesktopmanager.free"
cat << EOF > $HOME/.local/bin/remotedesktopmanager.free
#!/bin/bash
cd ~/.local/bin/RemoteDesktopManager.Free
./RemoteDesktopManager.Free
EOF

echo "Creating .desktop shortcut $HOME/.local/share/applications/remotedesktopmanager.free.desktop"
cat << EOF > $HOME/.local/share/applications/remotedesktopmanager.free.desktop
[Desktop Entry]
Version=1.1
Type=Application
Name=Remote Desktop Manager Free
Exec=$HOME/.local/bin/RemoteDesktopManager.Free/RemoteDesktopManager.Free
Path=$HOME/.local/bin/RemoteDesktopManager.Free
Icon=$HOME/.local/share/icons/remotedesktopmanager.free.png
Terminal=false
EOF

if [ -d "$TMP_DIR" ]; then
	echo "Removing temporary dir - $TMP_DIR"
	rm -rf $TMP_DIR
fi