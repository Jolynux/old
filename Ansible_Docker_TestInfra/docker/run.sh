#!/bin/bash

set -e

/set_root_pw.sh
mkdir -p /run/sshd
exec /usr/sbin/sshd -D