# OS/Hypervisor

I use Proxmox as my hypervisor, but you can use any OS/hypervisor depending on your needs and whether or not you intend to use linux containers (LXCs) or not.

Honestly, you're better off just watching this [YouTube video](https://www.youtube.com/watch?v=lFzWDJcRsqo)

To be updated at some point...

* Download ISO from [Proxmox](https://proxmox.com/en/downloads/proxmox-virtual-environment/iso)
* Boot blah blah blah

# Tailscale

Set up Tailscale. Find instructions [here](https://tailscale.com/docs/install/linux) or just follow along below:

1. Install Tailscale client and follow instructions. Ideally make sure you already have a Tailscale account set up to reduce friction:

```
curl -fsSL https://tailscale.com/install.sh | sh
```

2. Start Tailscale Client:

```
sudo tailscale up
```

3. Check that your device shows up on the Tailscale [Admin Console](https://login.tailscale.com/admin/machines)


# Create a Linux Container (LXC)

The YouTube video linked above will also guide you through the process.

# After LXC Creation

### Download Docker:

```
sudo apt-get update
sudo apt-get install ./docker-desktop-amd64.deb
```

# Router Setup

My home network is made up of my Internet Service Provider's (ISP) modem/router which has a Google WiFi mesh network connected to it, used as my house's primary network. In order to separate my webserver from the rest of my network, I found an old WRT54G router and flashed it with DD-WRT.

## Port Forwarding

To be updated...

# Helpful Upgrades (Optional)

### GUI File Manager

I tried Midnight Commander. It's decent, I guess?

To download:
```
apt-get install mc
```

### Another Text Editor

Honestly, Nano is completely fine. But you can try Micro if you'd like.

To download:
```
apt install micro
```
