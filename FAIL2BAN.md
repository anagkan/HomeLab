1: Install Fail2Ban

```
apt update && apt install -y fail2ban
```
2: Jail

edit /etc/fail2ban/filter.d/authelia.conf with:

```
[Definition]
  # Official Authelia filter (https://www.authelia.com/overview/security/measures/)
  # plus WebAuthn. Catches failed 1FA (password) AND failed 2FA attempts, and
  # username-enumeration probes against the password-reset endpoints.
  failregex = ^.*Unsuccessful (1FA|TOTP|Duo|U2F|WebAuthn) authentication attempt by user .*remote_ip"?(:|=)"?<HOST>"?.*$
              ^.*user not found.*path=/api/reset-password/identity/start remote_ip"?(:|=)"?<HOST>"?.*$
              ^.*Sending an email to user.*path=/api/.*/start remote_ip"?(:|=)"?<HOST>"?.*$
  ignoreregex = ^.*level"?(:|=)"?info.*
                ^.*level"?(:|=)"?warning.*
```

Create the Jail

edit /etc/fail2ban/jail.d/authelia.conf

```
[authelia]
  enabled = true
  port = http,https,9091
  filter = authelia
  logpath = /root/HomeLab/authelia/data/authelia.log
  # Never ban LAN or Tailscale (TOTP device registration and password resets
  # hit the /api/.../start regex above, so your own setup work counts as hits).
  ignoreip = 127.0.0.1/8 192.168.3.0/24 100.64.0.0/10
  maxretry = 3
  bantime = 1d
  findtime = 1d
  # DOCKER-USER, not FORWARD or INPUT: traffic to Docker-published ports is
  # forwarded, so INPUT never sees it, and Docker re-inserts its own jump at
  # the top of FORWARD on restart. The chain MUST be set inside the action
  # brackets — a standalone "chain =" option is ignored when action is set
  # explicitly (it only interpolates via the default banaction), leaving the
  # ban on INPUT where it never matches.
  action = iptables-allports[name=authelia, chain=DOCKER-USER]
```

Start Fail2Ban

```
systemctl enable fail2ban && systemctl restart fail2ban
```

Check is FAIL2BAN is running

```
fail2ban-client status authelia
```

Verify the filter matches the log (shows hit counts per regex):

```
fail2ban-regex /root/HomeLab/authelia/data/authelia.log /etc/fail2ban/filter.d/authelia.conf
```

Test it:

Go to auth.example.com and log in 3 times with incorrect username/passwords
(from a non-ignored IP, e.g. mobile data)

Unban by:
```
fail2ban-client set authelia unbanip [ip address]
```

## Coverage notes (OIDC)

- Vikunja and SparkyFitness log in **through the Authelia portal** (OIDC), so
  this single jail covers their logins too — no per-app jail needed as long as
  local/email login stays disabled in those apps.
- Not covered: SparkyFitness API keys (mobile app) and Vikunja API tokens —
  those are validated app-side and never appear in Authelia's log.
- Authelia's built-in regulation also throttles per-*user* (default: 3 fails
  in 2m bans the account 5m), which complements this per-IP ban.
