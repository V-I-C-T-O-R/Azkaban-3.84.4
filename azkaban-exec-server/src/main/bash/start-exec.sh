#!/bin/bash

script_dir=$(dirname $0)
# User Env For MySQL
HOSTNAME=`hostname -f`
PORT="3306"
USERNAME="azkaban"
PASSWORD="azkaban"
DBNAME="azkaban"
HOST="192.168.1.1"

# Azkaban Status
ID=5

# pass along command line arguments to the internal launch script.
${script_dir}/internal/internal-start-executor.sh "$@" > executorServerLog.log 2>&1 &
#自动激活exector节点
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
url="http://"$ip":12321/executor?action=activate"
sleep 5
curl $url

echo -e '\n\rupdate executor id start'

# MySQL Exc
MYSQL="mysql -u${USERNAME} -p${PASSWORD} -h${HOST} ${DBNAME}"
select_sql="select count(1) from executors where host='${HOSTNAME}'"
update_sql="update executors set id=${ID}  where host='${HOSTNAME}'"

while true
do
   res=`$MYSQL -e "$select_sql" 2>/dev/null | sed '1d'`
   if [ $res -eq 1 ];then
       break
   fi
   sleep 3
   echo -e "Executor haven't started...."
done

# Update
$MYSQL -e "$update_sql" 2>/dev/null
[ $? -eq 0 ] && echo "update executor id successed" || {
    echo "update executor id failed"
}
