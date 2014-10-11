#!/usr/bin/env bash

#=====================================================
# Ubuntu Gnome Desktop, Google Chrome, Firefox, Fonts
#=====================================================
sudo wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" \
    | sudo apt-key add -
# Need sh -c since redirection is performed by your shell which does not have sudo
sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list"
sudo apt-get -qqy update
sudo apt-get -qqy install ubuntu-gnome-desktop unity-gtk3-module unzip \
    fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable \
    xfonts-cyrillic google-chrome-stable firefox x11vnc xvfb

#==============================================
# Selenium, Chrome webdriver, VNC & XVfb Setup
#==============================================
sudo useradd --shell /bin/bash \
    --create-home --home /opt/headless headless
cd /opt/headless
sudo -u headless wget --no-verbose -O selenium-server-standalone.jar \
    "http://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar"
sudo -u headless rm -rf chromedriver
sudo -u headless wget --no-verbose -O chromedriver_linux64.zip \
    "http://chromedriver.storage.googleapis.com/2.11/chromedriver_linux64.zip"
sudo -u headless unzip chromedriver_linux64.zip
sudo -u headless chmod -R 755 chromedriver
sudo ln -fs /opt/headless/chromedriver /usr/bin/chromedriver
sudo mkdir -p /var/log/headless
sudo sh -c 'echo "99999" > /var/run/headless.pid'
sudo chown headless:headless /var/log/headless
sudo chown headless:headless /var/run/headless.pid
sudo -u headless mkdir -p /opt/headless/.vnc
# Create a random cookie (a 16-hex-digit string)
export COOKIE=`ps -ef | md5sum | cut -f 1 -d " "`
# Create the Xvfb authority file with the just-created cookie
export AUTHFILE=/opt/headless/Xvfb-4.auth
export DISPLAY=:4
# Don't worry if xauth says "file Xvfb-4.auth does not exist".
# The file will be created at that time.
sudo -E -u headless sh -c 'HOME=/opt/headless xauth -f $AUTHFILE add $DISPLAY MIT-MAGIC-COOKIE-1 $COOKIE'
# Add the cookie to the user's authority file
sudo -E -u headless sh -c 'HOME=/opt/headless xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $COOKIE'
# Set some VNC password
sudo -E -u headless sh -c 'x11vnc -storepasswd secret /opt/headless/.vnc/passwd'
sudo vim /etc/init.d/headless
# <== content from that file
sudo chown root:root /etc/init.d/headless
sudo chmod a+x /etc/init.d/headless
sudo -u headless vim /opt/headless/start_headless.sh
# <== content from that file
sudo chmod a+x /opt/headless/start_headless.sh
sudo update-rc.d headless defaults

#===============
# Test it works
#===============
sudo -u headless /etc/init.d/headless start
sudo service headless status
sudo -u headless /etc/init.d/headless stop
