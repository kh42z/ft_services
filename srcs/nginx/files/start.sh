#/bin/sh
echo "Creating user ${FT_USER}"
/usr/sbin/adduser -h /home/${FT_USER} -s /bin/sh -D ${FT_USER}
ID=$(id -u ${FT_USER})
GID=$(id -g ${FT_USER})
echo "${FT_USER}:${FT_PASSWORD}" |/usr/sbin/chpasswd
chown $ID:$GID /home/${FT_USER} -R
supervisord -c /etc/supervisord.conf
