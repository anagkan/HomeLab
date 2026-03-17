1: Install Fail2Ban

```
apt update && apt install -y fail2ban
```
2: Jail

edit /etc/fail2ban/filter.d/authelia.conf with:

```
[Definition]
  failregex = Unsuccessful 1FA authentication attempt by user .*remote_ip=<HOST>
  ignoreregex =
```

Create the Jail

edit /etc/fail2ban/jail.d/authelia.conf

```
[authelia]
  enabled = true
  port = http,https
  filter = authelia
  logpath = /root/HomeLab/authelia/data/authelia.log
  maxretry = 3
  bantime = 1h
  findtime = 5m
  action = iptables-allports[name=authelia, chain=FORWARD]
```

Start Fail2Ban

```
systemctl enable fail2ban && systemctl restart fail2ban
```

Check is FAIL2BAN is running

```
fail2ban-client status authelia
```

Test it:

Go to auth.example.com and log in 3 times with incorrect username/passwords

Unban by:
```
fail2ban-client set authelia unbanip [ip address]
```