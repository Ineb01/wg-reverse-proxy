#!/bin/bash
set -e

echo "=== Network Connectivity Check ==="
echo

echo "Checking if port 80 is properly forwarded..."
if curl -s http://ollama.wg.dphx.eu/.well-known/acme-challenge/test -o /dev/null; then
    echo "✅ Port 80 is accessible from the internet"
else
    echo "❌ Cannot access port 80 from the internet"
    echo "   Make sure your router is forwarding port 80 to this machine"
    echo "   and any firewalls are allowing inbound connections"
fi

echo

echo "Checking DNS resolution..."
if host ollama.wg.dphx.eu >/dev/null 2>&1; then
    echo "✅ DNS resolution successful"
    echo "   $(host ollama.wg.dphx.eu | grep "has address")"
    
    # Get the IP address
    SERVER_IP=$(curl -s https://ifconfig.me)
    DNS_IP=$(host ollama.wg.dphx.eu | grep "has address" | awk '{print $4}')
    
    if [ "$DNS_IP" == "$SERVER_IP" ]; then
        echo "✅ DNS points to this server's IP ($SERVER_IP)"
    else
        echo "❌ DNS points to $DNS_IP but your server's IP is $SERVER_IP"
    fi
else
    echo "❌ DNS resolution failed for ollama.wg.dphx.eu"
fi

echo

echo "Testing certbot connectivity to Let's Encrypt..."
docker compose run --rm certbot certbot certificates

echo

echo "=== NEXT STEPS ==="
echo "1. If DNS and port forwarding are correct, try this command:"
echo "   docker compose run --rm certbot certbot certonly --webroot -w /var/www/certbot --email benjamin.bachmayr@gmail.com --agree-tos --no-eff-email --force-renewal -d ollama.wg.dphx.eu --debug-challenges"
echo
echo "2. Logs can help diagnose issues:"
echo "   docker compose logs nginx"
echo "   docker compose logs certbot"
echo
echo "3. Once certificate is working, uncomment the HTTPS server in nginx/conf.d/ollama.wg.dphx.eu.conf"

chmod +x check-setup.sh
