#!/bin/bash

if [ -n "${DEBUG}" ]; then
 set -x
fi

# https://www.mysqueezebox.com/download
# # <p class="os"><img src="/static/images/os/windows.gif" alt="windows.gif" class="osicon"> Logitech Media Server v8.1.1</p>
VERSION=`curl -s "https://www.mysqueezebox.com/download" | grep 'Logitech Media Server v' | sed -n -e 's/^.*Logitech Media Server v'//p | sed -n -e 's/<\/p>.*$'//p`

echo ${VERSION}