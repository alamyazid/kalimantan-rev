#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

clear
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
domain=$(cat /etc/xray/domain)
tls=$(cat /etc/xray/vmessgrpc.json | grep port | awk '{print $2}' | sed 's/,//g')
vl=$(cat /etc/xray/vlessgrpc.json | grep port | awk '{print $2}' | sed 's/,//g')
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/vmessgrpc.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
read -rp "Masukkan Bug: " -e bug
uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/vmessgrpc.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/vlessgrpc.json
cat > /etc/xray/$user-tls.json << EOF
      {
      "v": "0",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "GunService",
      "type": "none",
      "host": "${bug}",
      "tls": "tls"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmesslink11="vmess://$(base64 -w 0 /etc/xray/$user-tls.json)"
vmesslink1="vmess://${uuid}@${domain}:${tls}/?type=grpc&encryption=auto&serviceName=GunService&security=tls&sni=${bug}#$user"
vmesslink2="vmess://${uuid}@${domain}:${tls}?mode=multi&security=tls&encryption=none&type=grpc&serviceName=GunService&sni=${bug}#$user"
vlesslink1="vless://${uuid}@${domain}:${vl}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=GunService&sni=${bug}#$user"
systemctl restart vmess-grpc.service
systemctl restart vless-grpc.service
service cron restart
clear
echo -e "══════════════════════" | lolcat
echo -e "=•=•=•=•=•=XRAY GRPC=•=•=•=•=•=" 
echo -e "══════════════════════" | lolcat
echo -e "Remarks           : ${user}"
echo -e "Domain            : ${domain}"
echo -e "Port VMess        : ${tls}"
echo -e "Port VLess        : ${vl}"
echo -e "ID                : ${uuid}"
echo -e "Alter ID          : 0"
echo -e "Mode              : Gun"
echo -e "Security          : TLS"
echo -e "Type              : grpc"
echo -e "Jaringan          : GRPC"
echo -e "Service Name gRPC : GunService"
echo -e "SNI               : ${bug}"
echo -e "══════════════════════" | lolcat
echo -e "Link VMess GRPC  : "
echo -e "=•=•=•=•=•=•=•=•=•=•="
echo -e "${vmesslink1}"
echo -e "=•=•=•=•=•=•=•=•=•=•="
echo -e "${vmesslink2}"
echo -e "=•=•=•=•=•=•=•=•=•=•="
echo -e "${vmesslink11}"
echo -e "══════════════════════" | lolcat
echo -e "Link VLess GRPC  : "
echo -e "=•=•=•=•=•=•=•=•=•=•="
echo -e "${vlesslink1}"
echo -e "══════════════════════" | lolcat
echo -e "${RED}AutoScriptSSH By TuanYZ${NC}"
echo -e "══════════════════════" | lolcat
echo -e""
read -p "Ketik Enter Untuk Kembali Ke Menu...."
sleep 1
menu
exit 0
fi
