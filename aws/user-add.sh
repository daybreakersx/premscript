#!/bin/bash
# Created by http://www.vps-murah.net
# Modified by 0123456

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Connecting to Server..."
sleep 0.5
echo "Checking Permision..."
sleep 0.4
CEK=0123456
if [ "$CEK" != "0123456" ]; then
		echo -e "${red}Permission Denied!${NC}";
        echo $CEK;
        exit 0;
else
echo -e "${green}Permission Accepted...${NC}"
sleep 1
clear
fi
  echo ""
  echo ""
  echo ""
read -p "        Username       : " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
echo "Username already exists in your VPS"
exit 0
else
read -p "        Password       : " password
read -p "        How many days? : " masa_aktif
MYIP=$(wget -qO- ipv4.icanhazip.com)
today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
clear
echo "Connecting to Server..."
sleep 0.5
echo "Creating Account..."
sleep 0.5
echo "Generating Host..."
sleep 0.5
echo "Generating Your New Username: $username"
sleep 0.5
echo "Generating Password: $password"
sleep 1

useradd $username
usermod -s /bin/false $username
usermod -e  $tanggal_expired $username
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$password\n$password" | passwd $username
  clear
  echo ""
  echo ""
  echo ""
  echo "---------------------------------------"
  echo "            ACCOUNT DETAILS            "
  echo "---------------------------------------" 
  echo "   Username        : $username"
  echo "   Password        : $password"
  echo "   Active Time     : $masa_aktif Days"
  echo "   Date Expired    : $tanggal_expired_display"
  echo "---------------------------------------"
  echo " "
  echo " "
  echo " "
fi
