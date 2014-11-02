# TODO: Freeze Chrome & Firefox versions along with Selenium versions tags

Example for Selenium 2.43.1

    dpkg -l | grep '^ii' | grep firefox
    #=> firefox               32.0.3+build1-0ubuntu0.14.04.1  amd64
    #=> firefox-locale-en     32.0.3+build1-0ubuntu0.14.04.1  amd64

    dpkg -l | grep '^ii' | grep google-chrome-stable
    #=> google-chrome-stable  37.0.2062.120-1  amd64
    
## Links

http://www.ubuntuupdates.org/pm/google-chrome-stable

http://www.ubuntuupdates.org/pm/firefox
https://github.com/leipreachan/docker-selenium/blob/968534a816565102fbfcc6a1973c06b7ad5e9174/firefox/Dockerfile#L10
ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/32.0.3/linux-x86_64/
ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/32.0.3/linux-x86_64/en-US/
