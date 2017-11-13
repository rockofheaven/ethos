#!/bin/bash
#wget -O /home/ethos/notify.sh https://raw.githubusercontent.com/MrSamorus/ethos/master/notify.sh
#sudo su
#chmod 777 /home/ethos/notify.sh
#crontab -e
#*/1 * * * * flock -n /tmp/notify.lock /home/ethos/notify.sh


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
