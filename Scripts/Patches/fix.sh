#!/bin/bash
cd /root
apt update
apt install unzip wget -y
echo "Installing Transmission"
apt install transmission-daemon -y
echo "Disabling BiglyBT"
systemctl stop biglybt > /dev/null 2>&1
systemctl disable biglybt > /dev/null 2>&1
echo "Disabling Transmission Daemon"
systemctl stop transmission-daemon > /dev/null 2>&1
systemctl disable transmission-daemon > /dev/null 2>&1
echo "Enabling Transmission for user pvr, please wait"
sed -i "/User=debian-transmission/c\User=pvr" /lib/systemd/system/transmission-daemon.service 
systemctl enable transmission-daemon > /dev/null 2>&1
systemctl start transmission-daemon > /dev/null 2>&1
systemctl stop transmission-daemon > /dev/null 2>&1
systemctl disable transmission-daemon > /dev/null 2>&1
echo "Replacing old config"
rm -rf /etc/transmission-daemon/settings.json
wget "https://raw.githubusercontent.com/radumamy/Termux-openSUSE/master/Scripts/Patches/settings.json" -O /etc/transmission-daemon/settings.json
chown debian-transmission:debian-transmission /etc/transmission-daemon/settings.json 
chmod 600 /etc/transmission-daemon/settings.json 
rm -rf /var/lib/pvr/.config/transmission-daemon/settings.json
cp /etc/transmission-daemon/settings.json /var/lib/pvr/.config/transmission-daemon/settings.json
chown pvr:pvr /var/lib/pvr/.config/transmission-daemon/settings.json 
chmod 600 /var/lib/pvr/.config/transmission-daemon/settings.json 
echo "Installing Comubustion Webui"
wget https://github.com/Secretmapper/combustion/archive/release.zip 
unzip release.zip > /dev/null 2>&1 
mv /usr/share/transmission/web /usr/share/transmission/web.old
mv combustion-release /usr/share/transmission/web
rm -rf release.zip
echo "Starting Transmission on port 9090"
systemctl enable transmission-daemon > /dev/null 2>&1
systemctl start transmission-daemon > /dev/null 2>&1
echo "Done"
