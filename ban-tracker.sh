#!/bin/bash

cp ./tracker /etc/ban-tracker
cat ./hosts >> /etc/hosts

cat <<- \EOF >> /etc/cron.daily/denypublic
IFS=$'\n'
L=$(/usr/bin/sort /etc/ban-tracker | /usr/bin/uniq)
for fn in $L; do
        /sbin/iptables -D INPUT -d $fn -j DROP
        /sbin/iptables -D FORWARD -d $fn -j DROP
        /sbin/iptables -D OUTPUT -d $fn -j DROP
        /sbin/iptables -A INPUT -d $fn -j DROP
        /sbin/iptables -A FORWARD -d $fn -j DROP
        /sbin/iptables -A OUTPUT -d $fn -j DROP
done
EOF

chmod +x /etc/cron.daily/denypublic
bash /etc/cron.daily/denypublic

