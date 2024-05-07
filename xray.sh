#!/bin/bash

# Stop and Disable Vproxy System Monitoring service
systemctl status vproxy-system-monitoring
systemctl stop vproxy-system-monitoring
systemctl disable vproxy-system-monitoring
systemctl status vproxy-system-monitoring

# Stop and Disable Vproxy service
systemctl status vproxy
systemctl stop vproxy
systemctl disable vproxy
systemctl status vproxy

# Backup configuration file if exists
if [ -f /usr/local/etc/xray/config.json ]
    then
        echo "Backup configuration file"
        cat /usr/local/etc/xray/config.json | jq > /root/config.json.bk
fi

# Remove Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
# Install Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root

# Create Xray configuration folder
mkdir -p /usr/local/etc/xray/config
# Create Xray configuration files
echo "{}" | jq > /usr/local/etc/xray/config/ipv4.json
echo "{}" | jq > /usr/local/etc/xray/config/ipv6.json

# Create Xray IPv6 systemd service
echo "[Unit]" > /etc/systemd/system/xray-ipv6.service
echo "Description=Xray IPv6 Service" >> /etc/systemd/system/xray-ipv6.service
echo "After=network.target nss-lookup.target" >> /etc/systemd/system/xray-ipv6.service
echo "" >> /etc/systemd/system/xray-ipv6.service
echo "[Service]" >> /etc/systemd/system/xray-ipv6.service
echo "User=root" >> /etc/systemd/system/xray-ipv6.service
echo "ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config/ipv6.json" >> /etc/systemd/system/xray-ipv6.service
echo "Restart=on-failure" >> /etc/systemd/system/xray-ipv6.service
echo "RestartSec=10" >> /etc/systemd/system/xray-ipv6.service
echo "" >> /etc/systemd/system/xray-ipv6.service
echo "[Install]" >> /etc/systemd/system/xray-ipv6.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/xray-ipv6.service

# Read Xray IPv6 systemd service file
cat /etc/systemd/system/xray-ipv6.service

# Reload systemd service
systemctl daemon-reload

# Enable and Start Xray IPv6 service
systemctl status xray-ipv6
systemctl enable xray-ipv6
systemctl start xray-ipv6
systemctl status xray-ipv6

# Restore configuration file if exists
if [ -f /root/config.json.bk ]
    then
        echo "Restore configuration file"
        cat /root/config.json.bk | jq > /usr/local/etc/xray/config.json
        rm -rf /root/config.json.bk
fi

# Check Vproxy configuration folder is exists
if [ -n "$(ls -la /etc/vproxy/proxy/ | grep "proxy-" | awk '{print $9}' | sort -n)" ]
    then
        # Remove Xray temporary configuration files
        rm -rf config.json
        rm -rf xray-inbounds.json
        rm -rf xray-outbounds.json
        rm -rf xray-rules.json

        # Create Xray temporary configuration files
        echo '{"routing":{"rules":[]},"inbounds":[],"outbounds":[]}' | jq >> config.json

        # Create Xray outbounds blackhole
        echo '{"tag":"outbounds-blackhole","protocol":"blackhole"}' | jq >> xray-outbounds.json

        # Create Xray routing rules blackhole
        echo '{"type":"field","source":["geoip:ad"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ae"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:af"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ag"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ai"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:al"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:am"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ao"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:aq"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ar"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:as"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:at"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:au"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:aw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ax"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:az"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ba"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bb"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bd"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:be"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bi"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bj"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bo"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bq"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:br"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bs"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:by"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:bz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ca"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cd"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ch"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ci"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ck"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:co"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cv"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cx"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cy"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:cz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:de"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:dj"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:dk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:dm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:do"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:dz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ec"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ee"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:eg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:eh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:er"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:es"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:et"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fi"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fj"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fo"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:fr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ga"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gb"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gd"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ge"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gi"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gp"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gq"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gs"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:gy"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:hk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:hn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:hr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ht"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:hu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:id"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ie"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:il"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:im"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:in"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:io"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:iq"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ir"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:is"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:it"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:je"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:jm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:jo"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:jp"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ke"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ki"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:km"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kp"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ky"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:kz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:la"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lb"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:li"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ls"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:lv"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ly"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ma"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:md"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:me"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ml"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mo"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mp"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mq"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ms"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mv"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mx"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:my"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:mz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:na"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ne"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ng"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ni"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:no"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:np"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:nz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:om"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pa"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pe"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ph"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ps"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:pw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:py"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:qa"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:re"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ro"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:rs"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ru"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:rw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sa"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sb"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sd"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:se"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sh"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:si"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sj"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:so"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ss"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:st"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sv"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sx"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sy"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:sz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:td"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:th"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tj"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tl"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tn"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:to"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tr"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tv"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:tz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ua"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ug"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:um"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:us"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:uy"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:uz"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:va"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:vc"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ve"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:vg"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:vi"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:vu"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:wf"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ws"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:xk"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:ye"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:yt"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:za"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:zm"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json
        echo '{"type":"field","source":["geoip:zw"],"outboundTag":"outbounds-blackhole"}' >> xray-rules.json

        # Create Xray inbounds, outbounds and rules
        for i in $(ls -la /etc/vproxy/proxy/ | grep "proxy-" | awk '{print $9}' | sort -n)
            do
                internal_ip=$(cat /etc/vproxy/proxy/$i/proxy.cfg | grep "proxy -" | awk '{print $6}' | awk -F '-i' '{print $2}')
                internal_port=$(cat /etc/vproxy/proxy/$i/proxy.cfg | grep "proxy -" | awk '{print $5}' | awk -F '-p' '{print $2}')
                external_ip=$(cat /etc/vproxy/proxy/$i/proxy.cfg | grep "proxy -" | awk '{print $7}' | awk -F '-e' '{print $2}')
                echo internal_ip: $internal_ip
                echo internal_port: $internal_port
                echo external_ip: $external_ip
                echo '{"tag":"inbounds-'$internal_port'","listen":"'$internal_ip'","port":'$internal_port',"protocol":"http","settings":{"timeout":0}}'
                echo '{"tag":"inbounds-'$internal_port'","listen":"'$internal_ip'","port":'$internal_port',"protocol":"http","settings":{"timeout":0}}' >> xray-inbounds.json
                echo '{"tag":"outbounds-'$internal_port'","protocol":"freedom","sendThrough":"'$external_ip'"}'
                echo '{"tag":"outbounds-'$internal_port'","protocol":"freedom","sendThrough":"'$external_ip'"}' >> xray-outbounds.json
                echo '{"type":"field","inboundTag":["inbounds-'$internal_port'"],"outboundTag":"outbounds-'$internal_port'"}'
                echo '{"type":"field","inboundTag":["inbounds-'$internal_port'"],"outboundTag":"outbounds-'$internal_port'"}' >> xray-rules.json
            done

        # Merge Xray configuration files
        jq '.inbounds += [inputs]' config.json xray-inbounds.json > config.json.tmp
        mv -f config.json.tmp config.json
        jq '.outbounds += [inputs]' config.json xray-outbounds.json > config.json.tmp
        mv -f config.json.tmp config.json
        jq '.routing.rules += [inputs]' config.json xray-rules.json > config.json.tmp
        mv -f config.json.tmp config.json

        # Copy Xray configuration files from temporary folder to Xray configuration folder
        cat config.json | jq > /usr/local/etc/xray/config/ipv6.json

        # Remove Xray temporary configuration files
        rm -rf config.json
        rm -rf xray-inbounds.json
        rm -rf xray-outbounds.json
        rm -rf xray-rules.json

        # Restart Xray IPv6 service
        systemctl status xray-ipv6
        systemctl restart xray-ipv6
        systemctl status xray-ipv6
fi

echo "Done"
