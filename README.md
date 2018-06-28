# Premium AutoScript

Premium autoscript installer used to install SSH, OVPN, and PPTP VPN on your VPS. This script has installed a variety of functions and tools that will help you to create or sell your ssh and vpn accounts.

### Installation:

For Centos 6 x86 & x64

`yum -y update && yum -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/req/centos6.sh && chmod +x centos6.sh && ./centos6.sh && rm -f centos6.sh && history -c`

For Centos 7 (OVPN not included)

`yum -y update && yum -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/centos7.sh && chmod +x centos7.sh && ./centos7.sh && rm -f centos7.sh && history -c`

For Debian 7 x86 & x64

`apt-get -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/deb7.sh && chmod +x deb7.sh && ./deb7.sh && rm -f deb7.sh && history -c`

For Debian 8 x86 & x64 (PPTP VPN not working)

`apt-get -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/req/debian8.sh && chmod +x debian8.sh && ./debian8.sh && rm -f debian8.sh && history -c`


### Important Information:

- Fail2Ban

- Ddos Deflate

- IP Tables

- Webmin - http://VPSIP:10000/

- VnStat - http://VPSIP:85/vpnstat/

- MRTG - http://VPSIP:85/mrtg/

- OVPN Config - http://VPSIP:85/client.ovpn | http://VPSIP:85/openvpn.tar.gz or http://VPSIP:85/client.tar for Centos

### Service and Port Informations:
OpenVPN : TCP 1194
OpenSSH : 22 & 143
Stunnel4 : 443
Dropbear : 109, 110 & 442
Squid Proxy : 80, 8000, 8080, 8888 & 3128
PPTP VPN : 1732
Badvpn : 7300
Nginx : 85

### Server Tools:
htop
iftop
mtr
nethogs
screenfetch


### Credits:

Hosting Termurah & VPS-Murah
