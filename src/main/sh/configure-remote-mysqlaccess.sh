#!/bin/bash
 sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
sudo mysql -uroot -proot < /tmp/add-user.sql
sudo mysql -uroot -proot < /tmp/db-schema.sql