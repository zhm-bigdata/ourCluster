172.20.107.93 hadoop100
172.26.112.93 hadoop101
172.25.185.162 hadoop102
172.25.185.163 hadoop103
172.26.112.94 hadoop104


bin/kafka-topics.sh --bootstrap-server xxx.xx.xx:9092  --list

bin/kafka-console-consumer.sh --topic xxxtopic --bootstrap-server xxx.xx:9092 

----------------------------------------------------------------------------------------------------------------

## 分发脚本 rsync.sh
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

----------------------------------------------------------------------------------------------------------------

 // 查看各节点状态脚本 checks.sh
 #!/bin/bash
if [ ! -e $1 ];then
 echo '参数错误，至少有一个参数'
 exit
fi

COMMAND=$1
for (( i=100;i<=104;i++ ))
do
  echo "----------hadoop$i-----------"
  echo `ssh hadoop$i $COMMAND`
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
    ----------------------简化版,上面的不对
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

----------------------------------------------------------------------------------------------------------------

# hadoop 群起

#!/bin/bash
if [[ $# -ne 1 ]]; then
    #statements
    echo 参数有误，有且只能有1个参数
fi

case $1 in
    "start")
        ssh hadoop101 start-dfs.sh
        ssh hadoop104 start-yarn.sh
    ;;
    "stop")
        ssh hadoop101 stop-dfs.sh
        ssh hadoop104 stop-yarn.sh
    ;;
esac


# zookeeper
 if [ ]
