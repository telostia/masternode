#!/bin/bash

#journalctl -fu docker.service
#journalctl -f
rm -f /ravendark/data/.lock /ravendark/data/ravendarkd.pid && \
ravendarkd -daemon -datadir=/root/data -conf=/root/conf/ravendark.conf && \
touch /root/data/debug.log && \
#cron  && \
#service rsyslog restart && \
tail -n 100 -f /root/data/debug.log
