# Route-ssh-config-toVPN
## Find IP and domain in ~/.ssh/config file to route that traffic goes to vpn.

This tool make from idea [ingerslev.io](https://ingerslev.io/2019-11-05-routing-macos-vpn-traffic/)
**ONLY SUPPORT MACOSX (10.14+)**

*  Add all Hostname config from your `~/.ssh/config` with route traffic to VPN gateway (VPN Side).
*  Other traffic will go through your local network gateway.

Don't forget TURN OFF ``Send all traffic over VPN connection`` at ``System Preferences\Network\VPN-name\Advanced``
``
## Run the script
```bash
'$' ./vpn-route.sh
Adding #!bin/sh to the first line
/sbin/route add 18.177.181.28 -interface $1
/sbin/route add 0.0.0.0/0 -interface $6
Write those value above to '/etc/ppp/ip-up' file, Proceed? [y/n]:
```

## Edit the /etc/ppp/ip-up
* You can add the other traffic manually (like local Subnet at VPN side).
```bash
$ sudo vi /etc/ppp/ip-up
/sbin/route add 172.16.99.0/16 -interface $1    # Local Subnet at VPN side
/sbin/route add 0.0.0.0/0 -interface $6         # Alaway add UNIQUE default route at the end of line in the file.
```