#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

mkdir -p /etc/ppp
routeFile='/etc/ppp/ip-up'

if [[ ! -e $routeFile ]]; then
    touch $routeFile
    chmod 0755 $routeFile
fi

routeIP (){
    ipConfig=$(cat ~/.ssh/config | grep -i HostName | awk '{print $2 }' | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.)')
    domainConfig=$(cat ~/.ssh/config | grep -i HostName | awk '{print $2 }'| egrep -v '([0-9]{1,3}\.){3}[0-9]{1,3}' | xargs dig +short | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.)')
    ip_array=($ipConfig $domainConfig)

    for i in "${!ip_array[@]}"
    do
        if grep -q ${ip_array[$i]} $routeFile; then
            unset ip_array[$i]
        else
            unique_ip_array+=(${ip_array[$i]})
        fi
    done

    if (( ${#unique_ip_array[@]} )); then

        printf "%s\n" "${unique_ip_array[@]}"
        echo -n "Write those IP above route to VPN in '/etc/ppp/ip-up' file, Proceed? [y/n]: "
        read ans

        if [[ $ans == y || $ans == yes || $ans == Y ]]; then
            sed -i '' 's/\/sbin\/route add 0.0.0.0\/0 \-interface \$6//' $routeFile

            for n in "${unique_ip_array[@]}"
            do
                echo "/sbin/route add $n -interface "`echo '$'`"1" >> $routeFile
                chmod 0775 $routeFile
            done

            echo '/sbin/route add 0.0.0.0/0 -interface $6' >> $routeFile
        else
            echo "Cancel Process"
        fi

    else
        echo "Nothing gonna change"
        exit 0
    fi
}

if grep -q "#\!/bin/sh" $routeFile; then
    routeIP
else
    echo 'Adding #!bin/sh to the first line'
    echo -e "#!/bin/sh\n$(cat $routeFile)" > $routeFile
    routeIP
fi