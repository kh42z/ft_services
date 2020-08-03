#/bin/sh
echo "Creating user ${FT_USER}"
/usr/sbin/adduser -h /var/ftp -s /bin/false -D ${FT_USER}
sed 's/{EIP}/'${EIP}'/g' -i /etc/vsftpd/vsftpd.conf
ID=$(id -u ${FT_USER})
GID=$(id -g ${FT_USER})
echo "${FT_USER}:${FT_PASSWORD}" |/usr/sbin/chpasswd
chown $ID:$GID /var/ftp/ -R
supervisord -c /etc/supervisord.conf
