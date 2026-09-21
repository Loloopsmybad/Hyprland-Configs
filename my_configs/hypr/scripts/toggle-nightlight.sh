#!/bin/bash
if pgrep -x gammastep > /dev/null; then
    pkill gammastep
else
    gammastep -t 3500:3500 &
fi
