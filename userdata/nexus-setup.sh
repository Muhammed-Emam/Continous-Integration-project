#!/bin/bash
# Install Java 8 and wget
yum install java-1.8.0-openjdk.x86_64 wget -y

# Create directories for Nexus
mkdir -p /opt/nexus/
mkdir -p /tmp/nexus/
cd /tmp/nexus/

# Download Nexus archive from the official website
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz

# Extract the archive and get the name of the directory it created
EXTOUT=`tar xzvf nexus.tar.gz`
NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`

# Remove the downloaded archive
rm -rf /tmp/nexus/nexus.tar.gz

# Copy Nexus files to the installation directory
rsync -avzh /tmp/nexus/ /opt/nexus/

# Create a new user for Nexus
useradd nexus

# Change ownership of the Nexus installation directory to the Nexus user
chown -R nexus.nexus /opt/nexus 

# Create a Systemd service file for Nexus
cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOT

# Set the run_as_user variable in the Nexus startup script
echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc

# Reload Systemd configuration
systemctl daemon-reload

# Start the Nexus service
systemctl start nexus

# Enable the Nexus service to start on boot
systemctl enable nexus























# #!/bin/bash
# yum install java-1.8.0-openjdk.x86_64 wget -y   
# mkdir -p /opt/nexus/   
# mkdir -p /tmp/nexus/                           
# cd /tmp/nexus/
# NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
# wget $NEXUSURL -O nexus.tar.gz
# EXTOUT=`tar xzvf nexus.tar.gz`
# NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`
# rm -rf /tmp/nexus/nexus.tar.gz
# rsync -avzh /tmp/nexus/ /opt/nexus/
# useradd nexus
# chown -R nexus.nexus /opt/nexus 
# cat <<EOT>> /etc/systemd/system/nexus.service
# [Unit]                                                                          
# Description=nexus service                                                       
# After=network.target                                                            
                                                                  
# [Service]                                                                       
# Type=forking                                                                    
# LimitNOFILE=65536                                                               
# ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
# ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
# User=nexus                                                                      
# Restart=on-abort                                                                
                                                                  
# [Install]                                                                       
# WantedBy=multi-user.target                                                      

# EOT

# echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc
# systemctl daemon-reload
# systemctl start nexus
# systemctl enable nexus
