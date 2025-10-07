#!/bin/bash
set -e

cd /mnt/c/Users/KDency/monitoring-phase3
source ./Scripts/update_inventory.sh

# Extract EC2 IP
EC2_IP=$(grep -oP '(?<=ansible_host=)[0-9\.]+' inventory.ini)

echo "🌐 Checking health for EC2: $EC2_IP"

# Backend health check
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_IP:8080/api/hello)
# Frontend health check
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_IP:5000)

echo "🧩 Backend status code: $BACKEND_STATUS"
echo "🧩 Frontend status code: $FRONTEND_STATUS"

if [ "$BACKEND_STATUS" == "200" ] && [ "$FRONTEND_STATUS" == "200" ]; then
  echo "✅ All services healthy."
else
  echo "❌ Some services failed health check!"
  exit 1
fi
