#!/bin/bash

# Function to thoroughly restart all services

restart_service() {
        local service_name=$1
        local service_path=$2
        local wait_time=${3:-5}

        echo "Restarting $service_name..."
        cd  "$service_path"

        docker compose down
        if [ $? -ne 0 ]; then
          echo "WARNING: Failed to stop $service_name"
      fi
        sleep  "$wait_time"

        docker compose up -d
         if [ $? -ne 0 ]; then
          echo "ERROR: Failed to start $service_name"
          return 1
      fi
        sleep  "$wait_time"
}

# Start in dependency order

restart_service  "Traefik"  "/root/HomeLab/traefik" 5
restart_service  "Authelia"  "/root/HomeLab/authelia"  5
restart_service  "DDNS-Updater"  "/root/HomeLab/ddns_updater" 5
restart_service  "BentoPDF"  "/root/HomeLab/bentopdf" 5
restart_service  "PairDrop"  "/root/HomeLab/pairdrop" 10
restart_service  "BookLore"  "/root/HomeLab/booklore" 20

echo ""
echo "=== Fail2Ban Status ==="
systemctl status fail2ban --no-pager

echo ""
echo "=== Container Status ==="
docker ps

echo ""
echo "=== Done ==="