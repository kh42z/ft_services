DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
CREATE USER 'ft_graf'@'%' IDENTIFIED BY 'ft_graf';
CREATE USER 'ft_wp'@'%' IDENTIFIED BY 'ft_wp';
CREATE DATABASE grafana;
GRANT ALL PRIVILEGES ON grafana.* TO 'ft_graf'@'%' IDENTIFIED BY 'ft_graf';
GRANT ALL PRIVILEGES ON wp.* TO 'ft_wp'@'%' IDENTIFIED BY 'ft_wp';
FLUSH PRIVILEGES;
