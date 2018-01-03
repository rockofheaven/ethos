#!/bin/bash
chatid=178774382
apikey=483833928:AAEW7ADJeX8UeWZB0k9YzwIZC_dxj_wnKGY
rigname=`grep loc /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)loc:\s*\(.*\)/\1\3/'`
xid=`dmesg -T -c | grep "NVRM: Xid" | grep -oE 'NVRM: Xid \(PCI:[^)]+\)' | cut -d':' -f4 | uniq | paste -sd','`
defunct=`grep defunct /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)defunct:\s*\(.*\)/\1\3/'`
dissallowed=`grep allowed /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)allowed:\s*\(.*\)/\1\3/'`
overheat=`grep overheat /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)overheat:\s*\(.*\)/\1\3/'`
throttled=`grep throttled /var/run/ethos/stats.file | sed 's/\(^\)\(.*\)throttled:\s*\(.*\)/\1\3/'`




if [ "$defunct" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} do not mining... Using clear-thermals. Failed cards: ${xid}" -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
		
if [ "$allowed" -eq 0 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} minestart" -d chat_id=${chatid}
		/opt/ethos/bin/allow
		exit 1
	fi

if [ "$overheat" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} overheated! Using clear-thermals/" -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
		
if [ "$throttled" -eq 1 ]
	then
		/usr/bin/curl -m 5 -s -X POST --output /dev/null https://api.telegram.org/bot${apikey}/sendMessage -d text="${rigname} throttled! Using clear-thermals/" -d chat_id=${chatid}
		/opt/ethos/bin/clear-thermals
		exit 1
	fi
	
