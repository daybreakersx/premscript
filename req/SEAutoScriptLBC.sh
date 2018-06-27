#!/bin/bash
# Created by 0123456

# Setting up SE
clear
echo " "
echo " "
echo "                   SOFTETHER LBC SET-UP                  "
echo "                  Auto-Script by 0123456                 "
echo " "
echo " "

# Input SE Credentials
HOST=""
SERVER_PASSWORD=""
USER=""
HUB=""
SE_PASSWORD=""

HOST=${HOST}
HUB=${HUB}
USER_PASSWORD=${SERVER_PASSWORD}
SE_PASSWORD=${SE_PASSWORD}

echo -n "Enter Server IP: "
read HOST
echo -n "Set Virtual Hub: "
read HUB
echo -n "Set ${HUB} Hub Username: "
read USER
read -s -p "Set ${HUB} Hub Password: " SERVER_PASSWORD
echo ""
read -s -p "Set SE Server Password: " SE_PASSWORD
echo ""
echo " "
echo "Installing Softether...."
echo " "

# Softether Installation
apt-get -y install dnsmasq
apt-get -y update && apt-get -y install build-essential
wget http://www.softether-download.com/files/softether/v4.27-9666-beta-2018.04.21-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9666-beta-2018.04.21-linux-x64-64bit.tar.gz
tar -xzf softether-vpnserver-v4.27-9666-beta-2018.04.21-linux-x64-64bit.tar.gz
rm -rf softether-vpnserver-v4.27-9666-beta-2018.04.21-linux-x64-64bit.tar.gz
cd && ls -a && cd vpnserver/ && ls -a
printf '1\n1\n1' | make

# Go to root
cd ..

# Move directory
mv vpnserver/ /usr/local/
cd /usr/local/vpnserver/
chmod 600 * /usr/local/vpnserver
chmod 755 /usr/local/vpnserver/vpncmd
chmod 755 /usr/local/vpnserver/vpnserver
chmod +x vpnserver
chmod +x vpncmd
cd
echo '#!/bin/sh
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable Softether by daemon.
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
TAP_ADDR=192.168.7.1
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
sleep 1
/sbin/ifconfig tap_soft $TAP_ADDR
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
sleep 1
/sbin/ifconfig tap_soft $TAP_ADDR
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver

# Start server and setup startup
chmod +x /etc/init.d/vpnserver
mkdir /var/lock/subsys
update-rc.d vpnserver defaults

# Forward ipv4
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward && sysctl --system

# Start and restart server
/etc/init.d/vpnserver restart
/etc/init.d/vpnserver start

# Configure dnsmasq
cat >> /etc/dnsmasq.conf <<END

interface=tap_soft
dhcp-range=tap_soft,192.168.7.50,192.168.7.60,12h
dhcp-option=tap_soft,3,192.168.7.1
END
/etc/init.d/dnsmasq restart

# Settings iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl --system
iptables -t nat -A POSTROUTING -s 192.168.7.0/24 -j SNAT --to-source ${HOST}
iptables-save > /etc/iptables.up.rules
/etc/init.d/vpnserver restart && /etc/init.d/dnsmasq restart
service dnsmasq restart && service vpnserver restart

# SSH brute-force protection
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set 
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP  

# Protection against port scanning
iptables -N port-scanning 
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN 
iptables -A port-scanning -j DROP

HOST=${HOST}
HUB_PASSWORD=${SE_PASSWORD}
USER_PASSWORD=${SERVER_PASSWORD}

TARGET="/usr/local/"

sleep 2
${TARGET}vpnserver/vpncmd localhost /SERVER /CMD ServerPasswordSet ${SE_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD HubCreate ${HUB} /PASSWORD:${HUB_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD UserCreate ${USER} /GROUP:none /REALNAME:none /NOTE:none
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD UserPasswordSet ${USER} /PASSWORD:${USER_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD BridgeCreate /DEVICE:"soft" /TAP:yes VPN
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:yes /PSK:vpn /DEFAULTHUB:${HUB}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ServerCertRegenerate ${HOST}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ServerCertGet ~/cert.cer
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD SstpEnable yes
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD Hub
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD HubDelete DEFAULT
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD VpnOverIcmpDnsEnable /ICMP:yes /DNS:yes


clear
echo "------------------------------------------------------------"
echo "                SOFTETHER CREDENTIALS                       "
echo "------------------------------------------------------------"
echo " "
echo "Host: ${HOST}"
echo "Virtual Hub: ${HUB}"
echo "Port: 443"
echo "Username: ${USER}"
echo "Password: ${SERVER_PASSWORD}"
echo "Server Password: ${SE_PASSWORD}"
echo " "
echo "-------------------- Created by 0123456 --------------------"
echo " "
echo " "