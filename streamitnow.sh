#!/bin/bash

function update_system() {
	yum -y update
}

function prerequisites() {
	yum -y install wget which vim ;
	yum -y install httpd ; 
}

function install_java() {
	wget --no-cookies --no-check-certificate --header "Cookie:oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm" -P /tmp ;
	yum -y localinstall /tmp/jdk-8u131-linux-x64.rpm
}

function verify_java_version() {
	java -version ;
}

function download_streama() {
	wget https://github.com/dularion/streama/releases/download/v1.1/streama-1.1.war -P /tmp ;
}

function configure_streama_pre() {
	mkdir /opt/streama ;
	mv /tmp/streama-1.1.war /opt/streama/streama.war ;
	mkdir /opt/streama/media ; 
	chmod 664 /opt/streama/media ; 
}

function create_streama_service() {
	echo " [Unit]
Description=Streama Server
After=syslog.target
After=network.target

[Service]
User=root
Type=simple
ExecStart=/bin/java -jar /opt/streama/streama.war
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=Streama

[Install]
WantedBy=multi-user.target " >> /etc/systemd/system/streama.service ;
}

function starting_services() {
	systemctl start httpd ;
        systemctl enable httpd ;	
	systemctl start streama ;
	systemctl enable streama ;
}

function services_status() {
	systemctl status httpd ; 
	systemctl status streama ; 
}

echo -e "\e[1;34m UPDATING THE SYSTEM   \e[0m"
update_system

echo -e "\e[1;34m INSTALLING PREREQUISITES  \e[0m"
prerequisites

echo -e "\e[1;34m INSTALLING AND COMPILING JAVA  \e[0m"
install_java

echo -e "\e[1;34m VERIFYING JAVA VERSION \e[0m"
verify_java_version

echo -e "\e[1;34m DOWNLOADING STREAM WAR PACKAGE \e[0m"
download_streama

echo -e "\e[1;34m COFIGURING STREAMA \e[0m"
configure_streama_pre

echo -e "\e[1;34m CREATING STREAMA SERVICE FILE \e[0m"
create_streama_service

echo -e "\e[1;34m STARTING AND ENABLING STREAMA SERVICE  \e[0m"
starting_services

echo -e "\e[1;36m STREAMA SERVICE STATUS \e[0m"
services_status

