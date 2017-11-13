#!/bin/bash

CHATID=178774382
APIKEY=452969473:AAEaoONOZJ_HPNXlbCtomghLodZOpfWzv5A
TELEGRAM_ALERT_APIKEY="452969473:AAEaoONOZJ_HPNXlbCtomghLodZOpfWzv5A"


NAME=$(hostname)
ERROR=$(dmesg -T |grep Xid |sed 's|.*Xid ||' |sed -r 's/,.+//')

MSG="RIG: $NAME

$ERROR "



if [[ $ERROR = *[!\ ]* ]];
  then
    /usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${APIKEY}/sendMessage -d "text=${MSG}" -d chat_id=${CHATID}
  else
    sleep 10
  fi
