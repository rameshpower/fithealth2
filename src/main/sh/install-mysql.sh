#!/bin/bash
source /tmp/expect-mysql-secure-install.sh
STATUS_OF_MYSQL=0


function checkMysqlInstalledStatus()
 {
  MYSQL_INSTALL_RESULT=$(dpkg -s mysql-server-8.0)
  if [[ $MYSQL_INSTALL_RESULT == *"install ok installed"* ]]; then
  STATUS_OF_MYSQL=1
  fi
}

function checkAndInstalldebConfUtils()
{
 DEBCONF_STATUS=$(dpkg -s debconf-utils)
 if [[ $DEBCONF_STATUS == *"install ok installed"* ]]; then
  echo:"INFO :: debconf-utils package is already installed, so skipping"
 else
 echo "INFO :: debconf-utils is not found,so installing..."
 sudo apt install -y debconf-utils
 fi
}
function checkExpectAndInstall()
{ 
    EXPECT_STATUS=$(dpkg -s expects)
    if [[ $EXPECT_STATUS -eq *"install ok installed"*  ]]; then
       echo "INFO:expect is already installed so skipping"
       else
       echo "INFO:INstalling expect package"
       sudo apt install -y expect
    fi

}

function installMySqlServer()
{
 checkAndInstalldebConfUtils
     echo "INFO : : Seeding  key value pair into debconf untils before installing it "
     echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
     echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
     export DEBIAN_FRONTEND="noninteractice"
     sudo apt -y install mysql-server-8.0
     MYSQL_INSTALLATION_STATUS=$?
     return $MYSQL_INSTALLATION_STATUS
}

sudo apt -y update
checkMysqlInstalledStatus
if [ $STATUS_OF_MYSQL -eq  0 ]; then
 echo "INFO ::  mysql is not installed plz installing the software before using it"
 installMySqlServer
 MYSQL_INSTALLED_STATUS=$?
  if [ $MYSQL_INSTALLED_STATUS -eq  0 ]; then
     echo "INFO : : mysql installed success fully"
     checkExpectAndInstall
     secureMysqlInstall
     else
     echo "Error: mysql installation failed please check the logs"
     exit 100
   fi
else
 echo "INFO :: mysql  is aleady installed "
fi
