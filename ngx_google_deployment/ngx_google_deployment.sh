#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
echo"#=============================================================================
#                   ngx_google_deployment Install Shell
# Version :         0.1 alpha 1
# Script author :   Charisma<github-charisma@32mb.cn>
# Blog :            http://blog.iplayloli.com
# System Required : Debian
# Project url :     https://github.com/Shell_Collections/ngx_google_deployment
# Thanks To :       arnofeng<http://github.com/arnofeng>
#============================================================================="
function install {
#1.Rootcheck
	rootness
#2.Configure
	configure
	source "$HOME/nginx_onekey_config"
#3.Install nginx
	test -d "$install_temp" || mkdir -p "$install_temp"
	cd "$install_temp"
	wget -N --no-check-certificate https://raw.githubusercontent.com/Char1sma/Shell_Collections/master/Nginx_OneKey/$system/install.sh
	chmod +x install.sh
	bash ./install.sh
#4.Download nginx config file
	cd "$install_path"
	test -d "$install_path/conf" || mkdir "$install_path/conf"
	cd "$install_path/conf"
	if [ -f "./nginx.conf" ]; then
		mv nginx.conf nginx.conf.bak
	fi
	wget -N --no-check-certificate https://raw.githubusercontent.com/Char1sma/Shell_Collections/master/ngx_google_deployment/nginx.conf
	sed -i "s/g.doufu.ru/$search_domain/" nginx.conf
	sed -i "s/x.doufu.ru/$scholar_domain/" nginx.conf
	test -d "$install_path/conf/vhost" || mkdir "$install_path/conf/vhost"
#5.mkdir /var/www/
	test -d /var/www/google || mkdir -p /var/www/google
	cd /var/www/google
	wget -N --no-check-certificate https://raw.githubusercontent.com/Char1sma/Shell_Collections/master/ngx_google_deployment/index.html
	sed -i "s/g.doufu.ru/$search_domain/" /var/www/google/index.html
	sed -i "s/x.doufu.ru/$scholar_domain/" /var/www/google/index.html
#6.SSL Key
	sslcert
#7.start nginx
	"$install_path/sbin/nginx"
	if [ $? -eq 0 ]; then
		echo "#Everything seems OK!"
		echo "#Go ahead to see your google!"
		echo "#!!!Do not modify nginx.conf!!!"
	else
		echo "#Installing errors!"
		echo "#Reinstall OR Contact me!"
	fi
}
function configure {
#."$HOME/nginx_onekey_config" > /dev/null 2>&1 || echo "Config now found!"
#	Configure settings when config file is not exixts
	if [ ! -f "$HOME/nginx_onekey_config" ]; then
		conf_q
	else
		echo "It seems that you cofigured ever?"
		echo "Do you want to re-configure(Y/n)?"
		read -r key3
		case "$key3" in
			N/n)
				echo "Do nothing";;
			*)
				rm "$HOME/nginx_onekey_config" -rf
				conf_q;;
		esac	
	fi
}
function conf_q {
echo -n "Select which you want:
1.Install for Debian/Ubuntu
2.Install for Centos
Your choice:"
		read -r key
		case "$key" in
			1)
				system=Debian;;
			2)
				system=Centos;;
			*)
			exit;;
		esac
		if [ "$system" = "Debian" ]; then
			echo -n "To be sure your system is Debian/Ubuntu,please enter 'y/yes' to continue: "
		elif [ "$system" = "Centos" ]; then
			echo -n "To be sure your system is Centos,please enter 'y/yes' to continue: "
		fi
		read -r key
		if [ "$key" = "yes" ]||[ "$key" = "y" ]; then
			read -p "Set your domain for google search: " search_domain
			read -p "Set your domain for google scholar: " scholar_domain
			if [ ! $search_domain ]||[ ! $scholar_domain ]||[ $search_domain = $scholar_domain ]; then
				echo "Two domains should not be null OR the same! Error happens!"
				exit 1
			else
				echo "your google search domain is $search_domain"
				echo "your google scholar domain is $scholar_domain"
				read -p "Press any key to continue ... " goodmood
			fi
		else
			exit 1
		fi
		cat >> "$HOME/nginx_onekey_config" << EOF
search_domain=$search_domain
scholar_domain=$scholar_domain
streamline=yes
compile_poz=no
install_temp=/tmp/ngx_google_deployment
nginx_ver=1.9.5
pcre_ver=8.37
pcre_mirror=http://sulinux.stanford.edu/mirrors/exim/pcre
ossl_ver=1.0.2e
ossl_mirror=http://mirrors.ibiblio.org/openssl/source
zlib_ver=1.2.7
zlib_mirror=http://78.108.103.11/MIRROR/ftp/png/src/history/zlib
mirror=https://raw.githubusercontent.com/char1sma/Shell_Collections/master/Nginx_OneKey/Mirrors
n_user=www
n_group=www
install_path=/usr/local/nginx
conf_path=/usr/local/nginx/conf/nginx.conf
log_path=/var/log/nginx
EOF
}
function rootness {
	if [[ $EUID -ne 0 ]]; then
		echo "Error:This script must be run as root!" 1>&2
		exit 1
	fi
}
function update {
#1.Rootcheck
	rootness
#2.Kill:80
	kill80
#2.Configure
	source "$HOME/nginx_onekey_config"
	read -p "Do you need to change your domain for google and schoolar?(y/N):" change
	if [ "$change" = "y" ] || [ "$change" = "Y" ]; then
		read -p "Set your domain for google search: " domain1
		read -p "Set your domain for google scholar: " domain2
		if [ ! $domain ]||[ ! $domain2 ]||[ $domain1 = $domain2 ]; then
				echo "Two domains should not be null OR the same! Error happens!"
				exit 1
			else
				echo "your google search domain is $search_domain"
				echo "your google scholar domain is $scholar_domain"
				read -p "Press any key to continue ... " goodmood
			fi
		cat >> "$HOME/nginx_onekey_config" << EOF
search_domain=$domain1
scholar_domain=$domain2
streamline=$streamline
compile_poz=$compile_poz
install_temp=$install_temp
nginx_ver=$nginx_ver
pcre_ver=$pcre_ver
pcre_mirror=$pcre_mirror
ossl_ver=$ossl_ver
ossl_mirror=$ossl_mirror
zlib_ver=$zlib_ver
zlib_mirror=$zlib_mirror
mirror=$mirror
n_user=$n_user
n_group=$n_group
install_path=$install_path
conf_path=$conf_path
log_path=$log_path
EOF
		rm "/var/www/ssls/$searchdomain.*" -rf
		sslcrt;
	fi
#3.Update
	cd "$install_path/conf/"
	mv -f nginx.conf nginx.conf.bak
#	wget -N --no-check-certificate https://raw.githubusercontent.com/Char1sma/Shell_Collections/master/ngx_google_deployment/nginx.conf
	wget -N --no-check-certificate https://zhangzhe.32.pm/assets/nginx_onekey/nginx.conf
	sed -i "s/g.doufu.ru/$search_domain/" nginx.conf
	sed -i "s/x.doufu.ru/$scholar_domain/" nginx.conf
	"$install_path/sbin/nginx"
		if [ $? -eq 0 ]; then
		echo "#Everything seems OK!"
		echo "#Go ahead to see your google!"
		echo "#!!!Do not modify nginx.conf!!!"
	else
		echo "#Installing errors!"
		echo "#Reinstall OR Contact me!"
	fi
}
# Kill :80
function kill80 {
	lsof -i :80|grep -v 'PID'|awk '{print $2}'|xargs kill -9
	if [ $? -eq 0 ]; then
        echo ":80 process has been killed!"
	else
		echo "no :80 process!"
    fi
}
function sslcert {
	source "$HOME/nginx_onekey_config"
	mkdir -p /var/www/ssls
	cd /var/www/ssls
	openssl req -nodes -newkey rsa:2048 -keyout $search_domain.key -out $search_domain.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=$search_domain"
	openssl x509 -req -days 3650 -in $search_domain.csr -signkey $search_domain.key -out $search_domain.crt
	openssl req -nodes -newkey rsa:2048 -keyout $scholar_domain.key -out $scholar_domain.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=$scholar_domain"
	openssl x509 -req -days 3650 -in $scholar_domain.csr -signkey $scholar_domain.key -out $scholar_domain.crt
}
function uninstall {
#1.Rootcheck
	rootness
#2.Configure
	source "$HOME/nginx_onekey_config"
	read -p "Press any key to start uninstall or CTRL + C to exit..."
	"$install_path/sbin/nginx -s stop"
		# restore /etc/rc.local
    if [[ -s /etc/rc.local_bak ]]; then
        rm -f /etc/rc.local
        mv /etc/rc.local_bak /etc/rc.local
    fi
	rm "$isntall_path/*" -rf
	rm "$log_path" -rf
	rm "$HOME/nginx_onekey_config"
	rm -rf /var/www/google
	echo "#Ngx_google_deployment uninstall success!"
}
case $1 in
	h|H|help)
		echo "Usage: $0 [OPTION]"
		echo ""
		echo "Here are the options:"
		echo "install       install ngx_google_deployment"
		echo "uninstall     uninstall ngx_google_deployment"
		echo "update        update nginx.conf";;
	update)
		if [ -f "$HOME/nginx_onekey_config" ]; then
			update
		else
			echo "It seem that you don't have installed ngx_google_deployment"
		fi;;
	install)
		install;;
	uninstall)
		;;
	*)
		echo "$0 : invalid option -- '$1'"
		echo "Try '$0 help' for more infomation."
		exit 0;;
esac