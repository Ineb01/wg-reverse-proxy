# wg-reverse-proxy

A secure reverse proxy setup using Nginx and Let's Encrypt for services in the wg.dphx.eu domain.

## Setup Instructions

### 1. Initial Setup

Clone this repository and navigate to the project directory:

```bash
git clone https://github.com/yourusername/wg-reverse-proxy.git
cd wg-reverse-proxy
```

### 2. Start the Services

Start the Nginx and Certbot containers:

```bash
docker-compose up -d
```

### 3. Obtain SSL Certificate

To get a certificate for ollama.wg.dphx.eu:

```bash
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot -d ollama.wg.dphx.eu
```

For multiple subdomains:

```bash
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot -d subdomain1.wg.dphx.eu -d subdomain2.wg.dphx.eu
```

Note: For the wildcard certificate, you'll need to create TXT records in your DNS configuration when prompted.

### 4. Restart Nginx

After obtaining certificates, restart Nginx to apply the changes:

```bash
docker-compose restart nginx
```

## Configuration

### Adding a New Service

1. Create a new configuration file in `nginx/conf.d/` for your service
2. Obtain an SSL certificate for the subdomain if needed
3. Restart Nginx to apply the changes

### SSL Certificate Renewal

Certificates are automatically renewed by the certbot container. No manual action is required.

## Directory Structure

- `nginx/conf.d/`: Nginx configuration files
- `certbot/www/`: Web root for Let's Encrypt verification
- `certbot/conf/`: Let's Encrypt certificates and configuration

## Security

The reverse proxy is configured to restrict access to specified IP addresses. Modify the IP whitelist in the Nginx configuration files as needed.
