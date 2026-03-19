#!/bin/bash

# Function to thoroughly kill all docker services

stop_service() {
        local service_name=$1
        local service_path=$2
        local wait_time=${3:-5}

        echo "Stopping $service_name..."
        cd  "$service_path"

        docker compose down
        if [ $? -ne 0 ]; then
          echo "WARNING: Failed to stop $service_name"
      fi
        sleep  "$wait_time"
}

# Stop in reverse dependency order (applications first, then infrastructure)

# stop_service  "BookLore"  "/root/HomeLab/booklore" 5
# stop_service  "Jellyfin" "/root/HomeLab/jellyfin" 5
stop_service  "Monitoring" "/root/HomeLab/monitoring" 5
stop_service  "Omnitools"  "/root/HomeLab/omnitools" 5
stop_service  "Vikunja"  "/root/HomeLab/vikunja" 5
stop_service  "n8n"  "/root/HomeLab/n8n" 5
stop_service  "PairDrop"  "/root/HomeLab/pairdrop" 5
stop_service  "BentoPDF"  "/root/HomeLab/bentopdf" 5
stop_service  "DDNS-Updater"  "/root/HomeLab/ddns-updater" 5
stop_service  "Authelia"  "/root/HomeLab/authelia" 5
stop_service  "Traefik"  "/root/HomeLab/traefik" 5

echo ""
echo "=== Container Status ==="
docker ps

echo ""
echo "=== Done ==="
