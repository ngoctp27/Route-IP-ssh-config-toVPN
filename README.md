# Route-ssh-config-toVPN
## Find IP and domain in ~/.ssh/config file to route that traffic goes to vpn. MacOSX

At the beautyful day, when my city affected with covid-19 pademic. Everybody work from home and leave me alone standing at my company to maintain and watching property.

Our Router device and the bandwith internet has an issue. When too much user connect VPN, many employee WFH automatically disconnect from VPN. I think a solution to minimize that issue. And this reason I create this tool.


*  Add all Hostname from your ~/.ssh/config with route traffic to VPN side (VPN gateway).
*  Other traffic will through your local gateway.


## Run the script
```bash
./vpn-route.sh
Adding #!bin/sh to the first line
/sbin/route add 18.177.181.28 -interface $1
/sbin/route add 34.194.19.135 -interface $1
/sbin/route add 0.0.0.0/0 -interface $6
Write those value above to '/etc/ppp/ip-up' file, Proceed? [y/n]:
```

## Edit the /etc/ppp/ip-up
* You can add the other traffic manually (like local Subnet at VPN side).
```bash
sudo vi /etc/ppp/ip-up
/sbin/route add 10.10.199.0/24 -interface $1    # Local Subnet at VPN side
/sbin/route add 0.0.0.0/0 -interface $6         # Alaway add UNIQUE default route at the end bottom line of the file.
```