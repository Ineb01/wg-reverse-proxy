#!/bin/bash
set -e

# Create a temporary directory
TMPDIR=$(mktemp -d)
echo "Created temporary directory: $TMPDIR"

# Download the schema files from GitHub for the correct version (1.6.0-RC1)
echo "Downloading Guacamole schema files..."
wget -q https://raw.githubusercontent.com/apache/guacamole-client/1.6.0-RC1/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/001-create-schema.sql -P $TMPDIR
wget -q https://raw.githubusercontent.com/apache/guacamole-client/1.6.0-RC1/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/002-create-admin-user.sql -P $TMPDIR

# Replace default password 'guacadmin' with a more secure one - default: 'Password123!'
echo "Customizing admin user..."
sed -i "s/'guacadmin',PASSWORD('guacadmin')/'guacadmin',PASSWORD('Password123!')/" $TMPDIR/002-create-admin-user.sql

# Execute the SQL files
echo "Initializing database..."
docker exec -i mariadb mysql -u root -proot_password guacamole_db < $TMPDIR/001-create-schema.sql
docker exec -i mariadb mysql -u root -proot_password guacamole_db < $TMPDIR/002-create-admin-user.sql

# Clean up
echo "Cleaning up..."
rm -rf $TMPDIR

echo "Database initialization complete!"
echo "You can now log in to Guacamole with:"
echo "Username: guacadmin"
echo "Password: Password123!"
echo "(You should change this password after first login)"
