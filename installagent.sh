if [ -n "$DY_KEY" ]; then
    d_key=$DY_KEY
fi
if [ ! $d_key ]; then
    printf "\033[31mAPI key not available in DD_API_KEY environment variable.\033[0m\n"
    exit 1;
fi

#identify OS
KNOWN_DISTRIBUTION="(Debian|Ubuntu|RedHat|CentOS|openSUSE|Amazon|Arista|SUSE)"
DISTRIBUTION=$(lsb_release -d 2>/dev/null | grep -Eo $KNOWN_DISTRIBUTION  || grep -Eo $KNOWN_DISTRIBUTION /etc/issue 2>/dev/null || grep -Eo $KNOWN_DISTRIBUTION /etc/Eos-release 2>/dev/null || uname -s)

#identify root user
if [ $(echo "$UID") = "0" ]; then
    sudo_cmd=''
    printf "\033[31mThis operation requires superuser privilege. Please try again as root user\033[0m\n"
    exit 1;
else
    sudo_cmd='sudo'
fi

if [ -f /etc/debian_version -o "$DISTRIBUTION" == "Debian" -o "$DISTRIBUTION" == "Ubuntu" ]; then
    OS="Debian"
    wget https://github.com/Manikandan25/dyzaro/raw/master/dyzaro.deb
    $sudo_cmd dpkg -i dyzaro.deb
    $sudo_cmd cp /usr/bin/telegraf /usr/bin/dyzaro
    wget http://54.153.123.228/dyzaro/api/clientConfig/$d_key.conf
    dyzaro --config $d_key.conf

else
    brew update
    brew install telegraf
    $sudo_cmd cp /usr/local/bin/telegraf /usr/local/bin/dyzaro
    curl -O http://54.153.123.228/dyzaro/api/clientConfig/$d_key.conf
    dyzaro -config $d_key.conf
fi
