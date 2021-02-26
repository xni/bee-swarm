#!/bin/bash
#
# This is tool for export private key from Swarm
#
#

echo "
+----------------------------------------------------------------------
| Export private key from Swarm for CentOS/Ubuntu/Debian
+----------------------------------------------------------------------
| Copyright © 2015-2021 All rights reserved.
+----------------------------------------------------------------------
| https://t.me/ru_swarm Russian offical Swarm Bee TG
+----------------------------------------------------------------------
";sleep 5
PM="apt-get"
file1='main.go'
file2='go.sum'
file3='go.mod'


if [ $(id -u) != "0" ]; then
    echo "You need to be rood to run this tool. (Type: sudo su)"
    exit 1
fi

# check os
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
	if [[ $(command -v yum) ]]; then
		PM="yum"
	fi
else
	echo -e "
	This scripts does not support your system.
	Note: Only support Ubuntu 16+ / Debian 8+ / CentOS 7+ system
	" && exit 1
fi

Install_Main() {
	rm key.json
	if [ ! -d /usr/local/go/ ]; then
		wget https://golang.org/dl/go1.16.linux-amd64.tar.gz
		tar -C /usr/local -xzf go1.16.linux-amd64.tar.gz
		export PATH=$PATH:/usr/local/go/bin

	else
		echo 'Уже установлена Go-lang!'
	fi
	apt install gcc
	export PATH=$PATH:/usr/local/go/bin
	for (( i=1; i<3; i++ ))
		do
			if [! -f ${file${i}}]; then
				wget https://raw.githubusercontent.com/ethersphere/exportSwarmKey/master/pkg/${file${i}}
			fi
	done



	echo 'Версия Go: '; go version
	mkdir /root/bee-keys/
	find / -name "swarm.key" -exec cp {} /root/bee-keys/ \;
	echo "Введите пароль для ноды:"
	read  n
	echo 'Создание приватного ключа...'
	go run main.go /root/bee-keys/ $n > key_tmp.json
	sed 's/^[^{]*//' key_tmp.json > key.json
	rm key_tmp.json
	echo 'Ваш кошелёк: '; cat key.json | jq '.address'
	echo 'Ваш приватный ключ для экспорта: '; cat key.json | jq '.privatekey'
	echo 'Файл приватного ключа создан! key.json'
}
Install_Main