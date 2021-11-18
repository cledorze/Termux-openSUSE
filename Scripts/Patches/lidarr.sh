#!/bin/bash
echo "Installing Lidarr"
cd /root
wget https://github.com/Lidarr/Lidarr/releases/download/v0.8.1.2135/Lidarr.master.0.8.1.2135.linux.tar.gz 
tar xzf Lid*
mv Lidarr /opt/
cd /opt/
chown pvr:pvr -R Lidarr/
cd /root
rm -rf Lid*
echo "Creating service file"
cat << EOF | tee /etc/systemd/system/lidarr.service >/dev/null
[Unit]
Description=Lidarr Daemon
After=syslog.target network.target
[Service]
User=pvr
Group=pvr
UMask=0002
Type=simple
ExecStart=/usr/bin/mono /opt/Lidarr/Lidarr.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl enable lidarr.service >/dev/null
systemctl start lidarr.service >/dev/null 
echo "Started Lidarr on port 8686"
echo "Done"
