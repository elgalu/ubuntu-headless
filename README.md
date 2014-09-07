# Headless Service

Selenium standalone headless server with VNC access

## Installation

Follow instructions at [headless_install.sh](#file-headless_install-sh).

## Usage

Login to your Jenkins or headless EC2 ubuntu instance:

    ssh ubuntu-ci-machine

### Start service

Now time to start the service.

    sudo service headless start
    #=> Starting...Headless almost ready....Headless almost ready....All Done!

I recommend restarting (`restart` instead of `start`) the service on every e2e run.

### Check status

Status tells you where is the headless selenium server running and in which port VNC is listening in case you want to see live e2e testing:

    sudo service headless status
    #=> Status of Selenium standalone headless server with VNC access: 
    #=> Process 14355 at /var/run/headless.pid is open
    #=> Selenium 127.0.0.1:4444 is open
    #=> VNC 127.0.0.1:5904 is open

#### TODO

- Extract this gist into a more general github repo.

- Provide install recipe to avoid users having to follow instructions at `headless_install.sh` manually.

- Allow to CLI configure the DISPLAY, VNC port, selenium port. For now you can change all that by editing the files.

- Get rid of this warning:

> (gnome-terminal:22855): GLib-GIO-CRITICAL **: g_settings_get: the format string may not contain '&' (key 'monospace-font-name' from schema 'org.gnome.desktop.interface'). This call will probably stop working with a future version of glib.

- Allow `sudo service headless --random-port` to be able to spawn many headless selenium ports & VNC ports.
