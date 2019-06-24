#!/bin/bash

# SIGTERM-handler
term_handler() {
  echo "Get SIGTERM"
  /etc/init.d/dnsmasq stop
  /etc/init.d/hostapd stop
  kill -TERM "$child" 2> /dev/null
}

echo "deleting ap interface"
iw dev uap0 del

echo "recreating ap interface"
iw dev wlan0 interface add uap0 type __ap

echo "raise ap interface"
ifconfig uap0 up

if [ -z "$SSID" -a -z "$PASSWORD" ]; then
  ssid="ishiki"
  password="password"
else
  ssid=$SSID
  password=$PASSWORD
fi

sed -i "s/ssid=.*/ssid=$ssid/g" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase=.*/wpa_passphrase=$password/g" /etc/hostapd/hostapd.conf

/etc/init.d/hostapd start
/etc/init.d/dnsmasq start

# setup handlers
trap term_handler SIGTERM
trap term_handler SIGKILL

sleep infinity &
child=$!
wait "$child"
