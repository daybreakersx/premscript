# Premium Autoscript

Premium autoscript installer used to install SSH, OVPN, and PPTP VPN on your VPS. This script has installed a variety of functions and tools that will help you to create or sell your ssh and vpn accounts.

### How to install ###

For Centos 6 x86 & x64:
[code]
yum -y update && yum -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/centos6-kvm.sh && chmod +x centos6-kvm.sh && ./centos6-kvm.sh && rm -f centos6-kvm.sh && history -c
[/code]

For Debian 7 x86 & x64:
apt-get -y install wget && wget https://raw.githubusercontent.com/daybreakersx/premscript/master/debian7-kvm.sh && chmod +x debian7-kvm.sh && ./debian7-kvm.sh && rm -f debian7-kvm.sh && history -c


