#!/usr/bin/env bash

# sudo -u headless vim /opt/headless/start_headless.sh

# Validations
[ -z "$DISPLAY" ]       && die "Need to set DISPLAY"
[ -z "$AUTHFILE" ]      && die "Need to set AUTHFILE"
[ -z "$VNC_PORT" ]      && die "Need to set VNC_PORT"
[ -z "$SELENIUM_HOST" ] && die "Need to set SELENIUM_HOST"
[ -z "$SELENIUM_PORT" ] && die "Need to set SELENIUM_PORT"
[ -z "$PID_FILE" ]      && die "Need to set PID_FILE"

export SCREEN_WIDTH=1360
export SCREEN_HEIGHT=1020
export SCREEN_DEPTH=24
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

export JAVA=/usr/bin/java
export JAR_FILE=/opt/headless/selenium-server-standalone.jar

export SELENIUM_LOG=/var/log/headless/selenium.log
export XVFB_LOG=/var/log/headless/xvfb.log
export GNOME_LOG=/var/log/headless/gnomesession.log
export XTERMINAL_LOG=/var/log/headless/xterminal.log
export VNC_LOG=/var/log/headless/vncserver.log
export SRV_LOG=/var/log/headless/service.log

export DAEMON_OPTS="-Xmx500m -Xss1024k -jar $JAR_FILE"
export DAEMON_OPTS="$DAEMON_OPTS -host $SELENIUM_HOST -port $SELENIUM_PORT"

function_to_fork() {
    # Run Xvfb with 24-bit screen depth
    # Note: How to redirecto both stderr and stdout to the same file
    echo -n ..
    Xvfb $DISPLAY -auth $AUTHFILE -screen 0 $GEOMETRY -ac >$XVFB_LOG 2>&1  &
    sleep 1

    # Run the desktop environment
    # TODO: nohup yes or no?
    echo -n ....
    /etc/X11/Xsession gnome-session >$GNOME_LOG 2>&1  &
    sleep 1

    # Start a GUI xTerm to help debugging when VNC into the container
    # x-terminal-emulator -geometry 120x40+10+10 -title "x-terminal-emulator" &

    # Start a GUI xTerm to easily debug the headless instance
    echo -n ......
    # export UBUNTU_MENUPROXY="1" , --disable-factory
    x-terminal-emulator -geometry 100x30+10+10 -title LocalSelHeadless \
         -e "$JAVA $DAEMON_OPTS" 2>&1 | tee $XTERMINAL_LOG  &

    # Block until selenium is up and running
    while ! nc -z $SELENIUM_HOST $SELENIUM_PORT; do sleep 1; done

    # Start VNC server to enable viewing what's going on but not mandatory
    # -localhost -autoport $VNC_PORT
    # -reopen
    echo -n ........
    x11vnc -forever -usepw -shared -listen localhost \
        -rfbport $VNC_PORT -display $DISPLAY >$VNC_LOG 2>&1  &

    # Block until selenium is up and running
    while ! nc -z 127.0.0.1 $VNC_PORT; do sleep 1; done

    echo -n Headless almost ready.
    wait
}

function_to_fork | tee $SRV_LOG  &
my_child_PID=$!

# Update $PID_FILE with forked one
echo -n $my_child_PID > /var/run/headless.pid

echo -n Starting...
while ! (cat $SRV_LOG | grep -m1 'Headless almost ready.'); do sleep 1; done
echo ...All Done!
