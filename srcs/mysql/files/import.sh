#/bin/bash


maxcounter=900

counter=0
while ! mysql -uroot -e "show databases;" > /dev/null 2>&1; do
    sleep 1
    counter=`expr $counter + 1`
	  echo "Waiting for MariaDB to be started: ${counter}"
    if [ $counter -gt $maxcounter ]; then
        >&2 echo "Cant wait more"
        exit 1
    fi;
done
sleep 1
mysql -uroot -Bse "CREATE USER '$FT_USER'@'%' IDENTIFIED BY '$FT_PASSWORD';GRANT ALL PRIVILEGES ON *.* TO '$FT_USER'@'%' IDENTIFIED BY '$FT_PASSWORD' WITH GRANT OPTION;"
sed 's/{EIP}/'${EIP}'/g' -i /opt/wp.sql
mysql -uroot < /opt/wp.sql
mysql -uroot < /opt/permissions.sql > /tmp/install.log 2>&1
touch /tmp/ready
