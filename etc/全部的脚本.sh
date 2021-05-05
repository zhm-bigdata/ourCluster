172.20.107.93 hadoop100
172.26.112.93 hadoop101
172.25.185.162 hadoop102
172.25.185.163 hadoop103
172.26.112.94 hadoop104

## 更改ip内部地址的脚本changeHosts.sh

if [[ $# -eq 1 ]]; then
    #statements
    echo 'Args number is wrong'
    exit
fi

for HOST_NAME in hadoop100 hadoop101 hadoop102 hadoop103 hadoop104 
do
    echo "--------------HOST_NAME-------------------------"
    ssh HOST_NAME `sudo sed -i 's/172.20.107.93/172.25.185.170/g'  /etc/hosts`
    ssh HOST_NAME `sudo sed -i 's/172.26.112.93/172.25.185.166/g'  /etc/hosts`
    ssh HOST_NAME `sudo sed -i 's/172.25.185.162/172.25.185.169/g'  /etc/hosts`
    ssh HOST_NAME `sudo sed -i 's/172.25.185.163/172.25.185.167/g'  /etc/hosts`
    ssh HOST_NAME `sudo sed -i 's/172.26.112.94/172.25.185.168/g'  /etc/hosts`
done




bin/kafka-topics.sh --bootstrap-server xxx.xx.xx.xx:9092  --list

bin/kafka-console-consumer.sh --topic xxxtopic --bootstrap-server xxx.xx.xx.xx:9092 

------------------------------------------zhm_rsync.sh----------------------------------------------------------------------

## 分发脚本 zhm_rsync.sh
#!/bin/bash

if [ $# -ne 1 ]; then
  echo '参数个数错误，只能输入一个'；
  exit;
fi

FILE_NAME=`basename $1`
DIR=`cd -P $(dirname $1);pwd`
echo "FILE_NAME="$FILE_NAME
echo "DIR="$DIR

for (( i=100;i<=104;i++ ))
 do
   rsync -av  $DIR/$FILE_NAME `whoami`@"hadoop"$i:$DIR/
 done

-------------------------------------------------zhm_checks.sh---------------------------------------------------------------

 // 查看各节点状态脚本 checks.sh
 #!/bin/bash, 字符串比较：==(判断两个字符串是否相当)、-z(字符串的值是否为空),-n(字符串的值是否不为空，相当于! -z)
if [ -z $1 ];then
 echo '参数错误，至少有一个参数'
 exit
fi

COMMAND=$*
for (( i=100;i<=104;i++ ))
do
  echo "----------hadoop$i-----------"
   ssh hadoop$i $COMMAND
done

----------------------------------------------------------------------------------------------------------------

// 自动添加环境变量脚本

    if [ $# -lt 3 ]; then
      echo '参数错误，至少有3个参数'
      exit
    fi
    APP=$1
    DIR=$2
    i=2
    for N in "$@"
    do
       case $i in 
        "2")

       #awk "END{print 'export $APP=$DIR'}" /etc/profile.d/my.env
       awk "END{print 'export $APP=$DIR'}" /app/test/test.sh
       i=$[ $i + 1 ];
       ;;
       *)
       awk "END{print 'export PATH=$PATH:$APP/$N''}" /app/test/test.sh
       ;;
       esac
    done
    ----------------------简化版,上面的不对....下面这个也不对。。。。。。。。。。
    if [ $# -lt 2 ]; then
      echo '参数错误，至少有2个参数'
      exit
    fi
    INDEX=$1
    APP=$2
    DIR=$3
    OHTER=$4
       case $INDEX in 
        "1")
       #awk "END{print 'export $APP=$DIR'}" /etc/profile.d/my.env
       awk "END{print export $APP=$DIR}" /app/test/test.sh
       awk "END{print export PATH=$PATH:$APP/$OHTER}" /app/test/test.sh
       i=$[ $i + 1 ];
       ;;
       *)
       awk "END{print export PATH=$PATH:$APP/$OHTER}" /app/test/test.sh
       ;;
       esac

------------依旧不对

----------------------------------------------------zhm_hadoop_cluster.sh-----------------------------------------------------------

# hadoop 群起  ---->filename= zhm_hadoop_cluster.sh

#!/bin/bash
if [[ $# -ne 1 ]]; then
    #statements
    echo 参数有误，有且只能有1个参数
fi

case $1 in
    "start")
        echo '-----------start hadoop--------------------'
        ssh hadoop101 start-dfs.sh
        ssh hadoop104 start-yarn.sh
    ;;
    "stop")
        echo '-----------stop hadoop--------------------'
        ssh hadoop101 stop-dfs.sh
        ssh hadoop104 stop-yarn.sh
    ;;
esac

--------------------------------------------------zhm_zookeeper_cluster.sh--------------------------------------------------------------

# zhm_zookeeper_cluster.sh

#!/bin/bash
 if [ ！ -n $1 ];then
    echo '参数个数错误'
    exit
 fi

 case $1 in
    "start")
    for HOST_NAME in hadoop102 hadoop103 hadoop104; do
     echo ---------- zookeeper $HOST_NAME 开始 ------------ 
     ssh $HOST_NAME zkServer.sh start
    done
    ;;
    "stop")
        for HOST_NAME in hadoop102 hadoop103 hadoop104; do
            echo ---------- zookeeper $HOST_NAME 停止 -----------
            ssh $HOST_NAME zkServer.sh stop
        done
    ;;
    "status")
        for HOST_NAME in hadoop102 hadoop103 hadoop104; do
            echo ---------- zookeeper $HOST_NAME 状态 -----------
            ssh $HOST_NAME "zkServer.sh status"
        done
    ;;
 esac

---------------------------------------------------zhm_kafka_cluster.sh-------------------------------------------------------------
# zhm_kafka_cluster.sh
#!/bin/bash
if [ $# -ne 1 ]; then
    echo "error：参数输入错误，有且仅能有1个参数"
    exit
fi

for HOST_NAME in hadoop102 hadoop103 hadoop104
 do
    echo ''
 done

 case $1 in
    "start")
        for HOST_NAME in hadoop102 hadoop103 hadoop104
         do
            echo "----------开始启动kafka $HOST_NAME----------"
            ssh $HOST_NAME kafka-server-start.sh -daemon /opt/app/kafka_2.11-2.4.1/config/server.properties
         done
    ;;
    "stop")
         for HOST_NAME in hadoop102 hadoop103 hadoop104
         do
            echo "----------开始停止kafka $HOST_NAME----------"
            ssh $HOST_NAME kafka-server-stop.sh
         done
    ;;
esac

---------------------------------------------------zhm_nginx.sh-------------------------------------------------------------
 # zhm_nginx.sh

#!/bin/bash
 if [ $# -ne 1 ];then
    echo "error：参数输入错误，有且仅能有1个参数"
    exit
 fi

 case $1 in
    "start")
        echo ------------------'hadoop101 start nginx'------------------
        ssh hadoop101 /opt/app/nginx/sbin/nginx -c /opt/app/nginx/conf/nginx.conf
    ;;
    "stop")
        echo ------------------'hadoop101 stop nginx'------------------
         ssh hadoop101 /opt/app/nginx/sbin/nginx -s stop
    ;;
    "reload")
        echo ------------------'hadoop101 reload nginx'------------------
        ssh hadoop101 /opt/app/nginx/sbin/nginx -s reload
    ;;
esac


-----------------------------------------------------zhm_hive.sh-----------------------------------------------------------
#zhm_hive.sh

#!/bin/bash
HIVE_LOG_DIR=/opt/logs/hive
if [ ! -d $HIVE_LOG_DIR ]
then
    mkdir -p $HIVE_LOG_DIR
fi
#检查进程是否运行正常，参数1为进程名，参数2为进程端口
function check_process()
{
    pid=$(ps -ef 2>/dev/null | grep -v grep | grep -i $1 | awk '{print $2}')
    ppid=$(netstat -nltp 2>/dev/null | grep $2 | awk '{print $7}' | cut -d '/' -f 1)
    echo $pid
    [[ "$pid" =~ "$ppid" ]] && [ "$ppid" ] && return 0 || return 1
}

function hive_start()
{
    metapid=$(check_process HiveMetastore 9083)
    cmd="nohup hive --service metastore >$HIVE_LOG_DIR/metastore.log 2>&1 &"
    cmd=$cmd" sleep 10; hdfs dfsadmin -safemode wait >/dev/null 2>&1"
    [ -z "$metapid" ] && eval $cmd || echo "Metastroe服务已启动"
    server2pid=$(check_process HiveServer2 10000)
    cmd="nohup hive --service hiveserver2 >$HIVE_LOG_DIR/hiveServer2.log 2>&1 &"
    [ -z "$server2pid" ] && eval $cmd || echo "HiveServer2服务已启动"
}

function hive_stop()
{
    metapid=$(check_process HiveMetastore 9083)
    [ "$metapid" ] && kill $metapid || echo "Metastore服务未启动"
    server2pid=$(check_process HiveServer2 10000)
    [ "$server2pid" ] && kill $server2pid || echo "HiveServer2服务未启动"
}

case $1 in
"start")
    hive_start
    ;;
"stop")
    hive_stop
    ;;
"restart")
    hive_stop
    sleep 2
    hive_start
    ;;
"status")
    check_process HiveMetastore 9083 >/dev/null && echo "Metastore服务运行正常" || echo "Metastore服务运行异常"
    check_process HiveServer2 10000 >/dev/null && echo "HiveServer2服务运行正常" || echo "HiveServer2服务运行异常"
    ;;
*)
    echo Invalid Args!
    echo 'Usage: '$(basename $0)' start|stop|restart|status'
    ;;
esac

-----------------------------------------------------hive--beeline-----------------------------------------------------------
#hive

beeline -u jdbc:hive2://hadoop102:10000 -n zhanghoumin


-----------------------------------------------------zhm_all_cluster.sh-----------------------------------------------------------
#zhm_all_cluster

#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo error：参数输入错误，有且仅能有1个参数
    exit
fi

function start(){
    zhm_nginx.sh start
    sleep 2s
    zhm_maxwell.sh start
    sleep 2s
    zhm_zookeeper_cluster.sh start
    sleep 6s
    zhm_hadoop_cluster.sh start
    sleep 10s
    zhm_kafka_cluster.sh start
    sleep 6s
    zhm_hive.sh start
    sleep 20s
}

function stop(){
    zhm_nginx.sh stop
    sleep 2s
    zhm_maxwell.sh stop
    sleep 2s
    zhm_hadoop_cluster.sh stop
    sleep 10s
    zhm_kafka_cluster.sh stop
    sleep 6s
    zhm_hive.sh stop
    sleep 20s
    sleep 6s
    zhm_zookeeper_cluster.sh stop
}


case $1 in
    "start")
        start
    ;;
    "stop")
        stop
    ;;
    *)
        echo 只能输入 start 或者 stop
    ;;
esac

-----------------------------------------------------zhm_all_cluster-----------------------------------------------------------
添加 echo

webserver  添加到 nginx脚本中



-----------------------------------------------------zhm_maxwell-----------------------------------------------------------


#!/bin/bash
if [ $# -ne 1 ];then
    echo '参数有误，有且只能有1个参数'
    exit
fi

case $1 in
    "start" )
    echo ------------------'hadoop101 start maxwell'------------------
    ssh hadoop101 nohup /opt/app/maxwell-1.25.0/bin/maxwell --config  /opt/app/maxwell-1.25.0/maxwell.properties >/dev/null 2>&1 &
    ;;
    "stop")
    echo ------------------'hadoop101 stop maxwell'------------------
    ssh hadoop101 ps -ef | grep maxwell | grep -v grep | awk '{print $2}' | xargs -n1 kill
    ;;
esac

-----------------------------------------------------zhm_webserver-----------------------------------------------------------

#!/bin/bash
if [[ $# -ne 1 ]]; then
    #statements
    echo '参数有误，有且只能有1个参数'
    exit
fi
case $1 in
    'start')
        echo ------------------'hadoop100 start webserver'------------------
        ssh hadoop100 nohup java -jar /opt/app/web-server-app/webserver-0.0.1-SNAPSHOT.jar >/dev/null 2>&1 &
        echo ------------------'hadoop101 start webserver'------------------
        ssh hadoop101 nohup java -jar /opt/app/web-server-app/webserver-0.0.1-SNAPSHOT.jar >/dev/null 2>&1 &
    ;;
    'stop')
        echo ------------------'hadoop100 stop webserver'------------------
        ssh hadoop100 ps -ef | grep webserver-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}' | xargs -n1 kill -9
        echo ------------------'hadoop101 stop webserver'------------------
        ssh hadoop101 ps -ef | grep webserver-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}' | xargs -n1 kill -9
    ;;
esac


-----------------------------------------------------zhm_redis_cluster.sh-----------------------------------------------------------
#!/bin/bash

if [ $# -ne 1 ];then
    echo "参数有误，有且只能有1个参数"
    exit
fi

case $1 in
    "start")
        for HOST_NAME in hadoop100 hadoop103 hadoop104
        do
            echo "------------------$HOST_NAME start redis-6379'------------------"
            ssh $HOST_NAME  /usr/local/bin/redis-server /opt/app/redis-3.0.4/myredis/redis-6379.conf
            echo "------------------$HOST_NAME start redis-6380'------------------"
            ssh $HOST_NAME redis-server /opt/app/redis-3.0.4/myredis/redis-6380.conf
        done
    ;;
    "stop")
        for HOST_NAME in hadoop100 hadoop103 hadoop104
        do
            echo "------------------$HOST_NAME stop redis------------------"
            # 效果和redis-cli -p 6379 shutdown一样，存盘，退出;
            # 此处后面必须加双引号（与此对应 $需转译）
                # 不加双引会报错（kill: sending signal to 1946 failed: No such process），因为在执行脚本的机器上kill的远程机器的pid；
                # 加飘号``会报错 kill用法不对---找不到kill的对象pid
            ssh $HOST_NAME "ps -ef | grep redis |grep -v grep| grep -v zhm_redis_cluster.sh| awk '{print \$2}'| xargs -n1 kill"
        done
    ;;
    "create")
        for HOST_NAME in hadoop100 hadoop103 hadoop104
        do
            echo "------------------$HOST_NAME start redis-6379'------------------"
            ssh $HOST_NAME /usr/local/bin/redis-server /opt/app/redis-3.0.4/myredis/redis-6379.conf
            echo "------------------$HOST_NAME start redis-6380'------------------"
            ssh $HOST_NAME redis-server /opt/app/redis-3.0.4/myredis/redis-6380.conf
        done
        echo "-----------------create cluster'------------------"
        sleep 5s
        /opt/app/redis-3.0.4/src/redis-trib.rb create --replicas 1 172.25.185.176:6379 172.25.185.176:6380 172.25.185.174:6379 172.25.185.174:6380 172.25.185.173:6379 172.25.185.173:6380 
    ;;
    *)
      echo "输入参数错误，只能为start/stop/create"
    ;;
esac



sed -i 's/logfile \"\"/logfile \"redis-6379.log\"/g' /opt/app/redis-3.0.4/myredis/redis-6379.conf
sed -i 's/logfile \"\"/logfile \"redis-6380.log\"/g' /opt/app/redis-3.0.4/myredis/redis-6380.conf


