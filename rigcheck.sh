#!/bin/bash
chatid=178774382
apikey=483833928:AAEW7ADJeX8UeWZB0k9YzwIZC_dxj_wnKGY
rigname=`grep loc /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)loc:\s*\(.*\)/\1\3/'`
xid=`dmesg -T -c | grep "NVRM: Xid" | grep -oE 'NVRM: Xid \(PCI:[^)]+\)' | cut -d':' -f4 | uniq | paste -sd','`
defunct=`grep defunct /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)defunct:\s*\(.*\)/\1\3/'`
nomine=`cat /var/run/ethos/nomine.file`
dissallowed=`grep allowed /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)allowed:\s*\(.*\)/\1\3/'`
overheat=`grep overheat: /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)overheat:\s*\(.*\)/\1\3/'`
overheatedgpu=`cat /var/run/ethos/overheatedgpu.file`
temp=`grep ^temp /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)temp:\s*\(.*\)/\1\3/'`
throttled=`grep throttled /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)throttled:\s*\(.*\)/\1\3/'`
adl_error=`grep adl_error /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)adl_error:\s*\(.*\)/\1\3/'`




if [ "$defunct" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} do not mining... Using clear-thermals. Failed cards: ${xid}" -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi

if [ "$nomine" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} do not mining... Using clear-thermals. Failed cards: ${xid}" -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
	
if [ "$adl_error" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} have ADL error and was rebooted. Failed cards: ${xid}" -d chat_id=${chatid}
		/opt/ethos/bin/r
		exit 1
	fi
		
if [ "$allowed" -eq 0 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} minestart." -d chat_id=${chatid}
		/opt/ethos/bin/allow
		/opt/ethos/bin/minestop
		sleep 5
		/opt/ethos/bin/minestart
		exit 1
	fi

if [ "$overheat" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} overheated! Overheated GPU: ${overheatedgpu} GPU temps: ${temp} Using clear-thermals." -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
		
if [ "$throttled" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} throttled!  GPU temps: ${temp} Using clear-thermals." -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
