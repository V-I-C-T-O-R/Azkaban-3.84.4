#!/bin/bash
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
url="http://"$ip":12321/executor?action=activate"
echo $url
curl $url
