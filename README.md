# Welcome

This project started back in September/October 2025 when I wanted to merge some PDFs together. I didn't like Mac's built-in tool, so I used a random web-based merger.

I knew no one cared about my Econometrics PSET, but I did think about the privacy concerns while I was uploading. And then I went down the self-hosting rabbit hole. During winter break of 2025-26, I first built a web server for my self hosting needs using an old OptiPlex 7010. It was glorious while it lasted, but not a week after returning to campus, the hard drive failed. Before I set up backups...

And now here we are.

This is my second attempt at building a personal web server for the sake of self-hosting a number of useful applications/services, as opposed to using a cloud-based option and giving out my data. This time, everything is backed up. This repo serves as documentation for myself and a way for anyone else who is interested in recreating my setup.

# Toplogy

```mermaid
graph TD
      subgraph Internet
          USER["👤 Users<br/>akanagala.com"]
          LE["Let's Encrypt"]
          PORKBUN["Porkbun DNS"]
      end

      subgraph Home Network
          MODEM["ISP Modem/Router<br/>Port 443 forwarded"]
          WRT["WRT54G DD-WRT<br/>Port 443 forwarded"]
          GOOGLE_WIFI["Google WiFi Mesh<br/>Home network (separate)"]

          subgraph Proxmox Host ["Dell OptiPlex 7010 — Proxmox VE (192.168.3.111)"]
              TAILSCALE["Tailscale<br/>SSH Access"]

              subgraph LXC ["Debian LXC Container (192.168.3.120) — 2 CPU, 4 GiB RAM"]
                  FAIL2BAN["Fail2Ban<br/>(native)"]

                  subgraph Docker ["Docker (proxy network)"]
                      TRAEFIK["Traefik<br/>Reverse Proxy<br/>:80 → :443"]
                      AUTHELIA["Authelia<br/>SSO/Auth"]
                      DDNS["DDNS-Updater"]

                      subgraph Apps ["Applications"]
                          BENTOPDF["BentoPDF"]
                          BOOKLORE["BookLore"]
                          JELLYFIN["Jellyfin"]
                          N8N["n8n"]
                          OMNI["OmniTools"]
                          PAIRDROP["PairDrop"]
                          VIKUNJA["Vikunja"]
                      end

                      subgraph Monitoring ["Monitoring Stack (monitoring network)"]
                          GRAFANA["Grafana"]
                          PROMETHEUS["Prometheus"]
                          NODE_EXP["Node Exporter"]
                          CADVISOR["cAdvisor"]
                      end
                  end
              end
          end
      end

      %% External traffic flow
      USER -->|"HTTPS :443"| MODEM
      MODEM -->|":443"| WRT
      WRT -->|":443"| TRAEFIK
      MODEM --- GOOGLE_WIFI

      %% Traefik routing
      TRAEFIK -->|"auth middleware"| AUTHELIA
      TRAEFIK --> BENTOPDF
      TRAEFIK --> BOOKLORE
      TRAEFIK --> JELLYFIN
      TRAEFIK --> N8N
      TRAEFIK --> OMNI
      TRAEFIK --> PAIRDROP
      TRAEFIK --> VIKUNJA
      TRAEFIK --> GRAFANA

      %% SSL & DNS
      TRAEFIK <-->|"DNS Challenge"| PORKBUN
      TRAEFIK <-->|"ACME Certs"| LE
      DDNS -->|"Syncs public IP"| PORKBUN

      %% Monitoring
      PROMETHEUS --> NODE_EXP
      PROMETHEUS --> CADVISOR
      PROMETHEUS --> AUTHELIA
      GRAFANA --> PROMETHEUS

      %% Fail2Ban
      FAIL2BAN -->|"Reads logs"| AUTHELIA

      %% SSH access
      TAILSCALE -.->|"SSH"| LXC

      %% Styling
      classDef critical fill:#ff6b6b,stroke:#c0392b,color:#fff
      classDef app fill:#74b9ff,stroke:#2980b9,color:#fff
      classDef monitoring fill:#a29bfe,stroke:#6c5ce7,color:#fff
      classDef infra fill:#55efc4,stroke:#00b894,color:#fff

      class TRAEFIK,AUTHELIA critical
      class BENTOPDF,BOOKLORE,JELLYFIN,N8N,OMNI,PAIRDROP,VIKUNJA app
      class GRAFANA,PROMETHEUS,NODE_EXP,CADVISOR monitoring
      class DDNS,FAIL2BAN,TAILSCALE infra
```

## Long Term Goals

* Set up a media stack: *arr stack + buy a NAS (expensive‼️)
    * I would like to collect some Linux ISOs...
* Spin up an LXC to mess around with local LLMs
    * GPU prices... 🫤
* Maybe switch to Nginx as my reverse proxy instead of Traefik. Unsure about this one because there is no need to overcomplicate my setup.

# Understanding this Repository

The vast majority of my services run in containers on Docker. To spin them up, I use Docker Compose and docker-compose.yaml files. I have chosen to give each service its own docker-compose.yaml file to make it easy to spin up and kill individual services as necessary. Each service that runs in docker gets its own subdirectory with a docker-compose.yml and any other necessary items.

### Docker Services:

* [Traefik](/traefik/README.md): Reverse Proxy that allows you to only expose one port to the internet. Handles all routing on the server.
* [Authelia](/authelia/README.md): Handles authentication for services that are private and not meant to be access by the whole internet
* [Vikunja](/vikunja/README.md): All-in-one ToDo List, Planner, etc
* [PairDrop](/pairdrop/README.md): Local file sharing. I might drop this one because Google is now supporting AirDrop on Android phones.
* [BentoPDF](/bentopdf/README.md): PDF Tools! The reason this entire project started.
* [BookLore](/booklore/README.md): E-Book reader/storage/archiver
* [Jellyfin](/jellyfin/README.md): 
* [OmniTools](/omnitools/README.md):
* [n8n](/n8n/README.md): Automation
* [Prometheus + Grafana](/monitoring/README.md): Visualizing data

### Non-Docker Services

* [Fail2Ban](FAIL2BAN.md): Works with Authelia to prevent brute-force attacks and unauthorized access.

# AI Use

Claude Code was incredibly helpful the first time I pieced my server together.
