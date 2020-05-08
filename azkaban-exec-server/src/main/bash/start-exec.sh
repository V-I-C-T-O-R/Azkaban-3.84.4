#!/bin/bash

script_dir=$(dirname $0)

# pass along command line arguments to the internal launch script.
${script_dir}/internal/internal-start-executor.sh "$@" >executorServerLog__`date +%F+%T`.out 2>&1 &

#自动激活exector节点
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
url="http://"$ip":12321/executor?action=activate"
sleep 3
curl $url
