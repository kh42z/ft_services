#/bin/bash
sleep 10
while [ ! -s "/var/lib/mysql/ibdata1" ]
do
	echo "Installing Mysql rep"
	rm -Rf /var/lib/mysql/*
	/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql/"
	sleep 5
done

/import.sh &
supervisord -c /etc/supervisord.conf
