CREATE DATABASE IF NOT EXISTS nextcloud;
CREATE USER IF NOT EXISTS 'nextcloud'@'%' IDENTIFIED BY 'nextpass123';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';

CREATE DATABASE IF NOT EXISTS guacamole_db;
CREATE USER IF NOT EXISTS 'guacamole_user'@'%' IDENTIFIED BY 'guacamole_password';
GRANT ALL PRIVILEGES ON guacamole_db.* TO 'guacamole_user'@'%';

FLUSH PRIVILEGES;
