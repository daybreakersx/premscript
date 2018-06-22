#!/bin/bash

#Requirement
apt-get -y install dnsmasq
apt-get -y update && apt-get -y install build-essential

#inisialisasi
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi

#install softether
wget http://www.softether-download.com/files/softether/v4.27-9666-beta-2018.04.21-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9666-beta-2018.04.21-linux-x64-64bit.tar.gz
tar -xzf softether-vpnserver-v4.27-9666-beta-2018.04.21-linux-x64-64bit.tar.gz
cd && ls -a && cd vpnserver/ && ls -a
printf '1\n1\n1' | make

#back to root
cd ..

#move directory
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 * /usr/local/vpnserver && chmod 755 /usr/local/vpnserver/vpncmd && chmod 755 /usr/local/vpnserver/vpnserver
chmod +x vpnserver
chmod +x vpncmd

echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver

###
chmod +x /etc/init.d/vpnserver && mkdir /var/lock/subsys && update-rc.d vpnserver defaults

###
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1
sysctl --system

#start server
/etc/init.d/vpnserver restart
/etc/init.d/vpnserver start

#Settings
/usr/local/vpnserver/vpncmd
# printf '1\n\n\nServerPasswordSet\nSetup123ScR\nSetup123ScR\n' | ./vpncmd
ServerPasswordSet
hubdelete DEFAULT
HubCreate VPN
BridgeCreate /DEVICE:"soft" /TAP:yes VPN
Hub VPN
UserCreate test
UserPasswordSet test
Hub VPN
IPsecEnable
ServerCertRegenerate $MYIP
ServerCertGet ~/cert.cer
SstpEnable yes
Hub
VpnOverIcmpDnsEnable /ICMP:yes /DNS:yes RESTART PUTTY
reboot
exit

#configure dnsmasq
cat >> /etc/dnsmasq.conf <<END
interface=tap_soft
dhcp-range=tap_soft,192.168.7.50,192.168.7.60,12h
dhcp-option=tap_soft,3,192.168.7.1
END
/etc/init.d/dnsmasq restart

# Finalizing
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl --system
iptables -t nat -A POSTROUTING -s 192.168.7.0/24 -j SNAT --to-source $MYIP
iptables-save > /etc/iptables.up.rules
/etc/init.d/vpnserver restart && /etc/init.d/dnsmasq restart
service dnsmasq restart && service vpnserver restart
reboot
