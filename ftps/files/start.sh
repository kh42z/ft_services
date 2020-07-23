#/bin/sh 
ID=$(id -u ${FTP_USER})
GID=$(id -g ${FTP_USER})
/usr/sbin/adduser -h /var/ftp -s /bin/false -D ${FTP_USER}
echo "${FTP_USER}:${FTP_PASSWORD}" |/usr/sbin/chpasswd
chown $ID:$GID /var/ftp/ -R
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
