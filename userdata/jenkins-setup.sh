#!/bin/bash
# Update the package list
sudo apt update

# Install OpenJDK 11
sudo apt install openjdk-11-jdk -y

# Install Maven
sudo apt install maven -y

# Download and install the Jenkins GPG key to verify packages
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add the Jenkins Debian package repository to the system
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list to include the Jenkins repository
sudo apt-get update

# Install Jenkins
sudo apt-get install jenkins -y

###
# This script installs OpenJDK 11, Maven, and Jenkins on a Debian-based system.

















# #!/bin/bash
# sudo apt update
# sudo apt install openjdk-11-jdk -y
# sudo apt install maven -y
# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
#   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update
# sudo apt-get install jenkins -y
# ###
