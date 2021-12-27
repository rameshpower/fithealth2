#!/bin/bash
IS_JDK_INSTALLED=0
IS_TOMCAT_INSTALLED=0
IS_TOMCAT_SERVICE_CONFIGURED=0

function checkJdkInstalled(){
    local JDK11_INSTALL_STATUS=$(dpkg -s openjdk-11-jdk)
if [[ $JDK11_INSTALL_STATUS == *"install ok installed"* ]]; then
IS_JDK_INSTALLED=1
fi
}

function installJdk()
{
    sudo apt -y install openjdk-11-jdk
    local JDK_STATUS=$?
    return $JDK_STATUS
}

function checkTomcateInstalled(){
    if [ -d $HOME/middleware/apace-tomacat-9.0.56/ ]; then
    IS_TOMCAT_INSTALLED=1
    fi

}

function installTomcate()
{
    mkdir -p $HOME/middleware
    cd $HOME/middleware
    wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.14/bin/apache-tomcat-10.0.14.tar.gz
    gunzip apache-tomcat-10.0.14.tar.gz
    tar -xvf apache-tomcat-10.0.14.tar
    rm  apache-tomcat-10.0.14.tar
    local TOMCAT_STATUS=$?
    return $TOMCAT_STATUS
}

function checkTomcatservice()
{

    sudo systemctl status tomcat
    local CHECK_TOMCAT_SERVICE_STATUS=$?
    if [ $CHECK_TOMCAT_SERVICE_STATUS -eq 0 ];
    then
    IS_TOMCAT_SERVICE_CONFIGURED=1
    else
    IS_TOMCAT_SERVICE_CONFIGURED=0
    fi
}
function tomcatService()
{
sed -i "s|#HOME|${HOME}|g" /tmp/tomcat.service.conf
sudo cp /tmp/tomcat.service.conf /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
sudo systemctl start tomcat
local TOMCAT_SERVICE_STATUS=$?
return $TOMCAT_SERVICE_STATUS
}
sudo apt -y update
checkJdkInstalled
if [ $IS_JDK_INSTALLED -eq 0 ]; then
echo "info jdk nt present instaling jdk"
installJdk
JDK_INSTALL_STATUS=$?
if [ $JDK_INSTALL_STATUS -eq 0 ]; then
echo "info jdk installed sccess"
else
echo "error installation jdk  failed please check the logs"
exit 100
fi

else
echo "info:jdk already installed"
fi

checkTomcateInstalled
if [ $IS_TOMCAT_INSTALLED -eq 0 ]; then
echo "INFO: tomcat server not installed installing now"
installTomcate
TOMACT_INSTALLED_STATUS=$?
if [ $TOMACT_INSTALLED_STATUS -eq 0 ]; then
echo "INfo tomcat servber installed success"
else
echo "error :tomcate installation failed "
exit 101
fi

else
echo "info: tomcate server already installed"
fi

checkTomcatservice
if [ $IS_TOMCAT_SERVICE_CONFIGURED -eq 0 ]; then
echo "infotomcate is not configure do configure it"
tomcatService
CONFIGURE_TOMCAT_SERVICE_STATUS=$?
if [ $CONFIGURE_TOMCAT_SERVICE_STATUS -eq 0 ]; then
echo "INFO: tocat configure success"
else
echo "eroor failed during configuring tomcat as service"
exit 102
fi
else
echo "info tomcat service is installed already"
fi