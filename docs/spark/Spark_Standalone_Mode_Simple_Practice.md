# Spark Standalone Mode Simple Practice

Spark 可以在单台机器上启动，非常方便用于测试。

## Install

单机的话，直接下载对应版本的 Spark 包解压即可。

## Starting

需要分别启动 Master 和 Worker，执行以下命令来：

```bash
#先启动 Master，然后启动 Worker
./sbin/start-master.sh
./sbin/start-slave.sh <master-spark-URL>
##或者
./sbin/start-all.sh
```

*master-spark-URL* 指 Master 的地址，表示 Worker 连接到的 Master，格式为：`spark://HOST:PORT` ，可以在 Master WebUI ( [http://localhost:8080](http://localhost:8080/) by default ) 中找到。

到目前为止，一个 standalone 模式的单节点 Spark 就可以正常运行了。

## Stoping

```bash
#先关闭 Worker，然后关闭 Master
./sbin/stop-slave.sh
./sbin/stop-master.sh
##或者
./sbin/stop-sll.sh
```

## Connecting an Application to the Cluster

只需将 *spark://IP:PORT* URL 传递给 SparkContext 构造器即可运行一个 Application。

### spark-shell

使用 interactive Spark shell 连接到集群：

```bash
./bin/spark-shell --master spark://IP:PORT
```

同时可以通过 *-total-executor-cores <numCores>* 选项控制 spark-shell 使用的核心数。

### spark-submit script

spark-submit script 方式是最直接的方式去提交一个 Application 到集群。有两种方式：

1. client mode：driver 与提交 Application 的 client 在同一个 process 中启动；
2. cluster mode：driver 在集群中 worker process 上启动，提交 Application 的 client 在完成提交后就会退出而不等待其完成。

使用 *-jars* 选项添加额外的依赖，比如：-jars jar1, jar2 。

使用 *-supervise* 选项开启失败任务重试。

spark-submit 提交 Application 格式：

```bash
./bin/spark-submit \
  --class <main-class> \
  --master <master-url> \
  --deploy-mode <deploy-mode> \
  --conf <key>=<value> \
  ... # other options
  <application-jar> \
  [application-arguments]
```

使用如下命令杀死 Application：

```bash
./bin/spark-class org.apache.spark.deploy.Client kill <master url> <driver ID>
```

driver 可以在 Master 的 WebUI 上找到。

## Monitoring and Logging

Spark 的 standalone 模式提供了基于 Web 的用户交户界面来监控集群。Master 和每个 Worker 都有对应的 WenUI 来展示集群和作业统计信息。

默认，8080 端口用于 Master，8081 用于 worker，可以通过配置文件或这命令参数中修改。

默认，每个作业的 log 输出会发送到每个 slave node 的对应目录（$SPARK\_HOME/work），包括两个文件 stdout 和 stderr，并且所有的输出都会写出道 console。

## Running Alongside Hadoop

可以在 Hadoop 集群上同时运行 Spark，把他们作为不同的服务即可。

使用 *hdfs://* URL ( hdfs://<namenode>:9000/path ) 访问 HDFS 的数据。

这个可以配合 Hadoop 的 Pseudo-Distributed 模式使用，在单机上做测试还是很舒服的。

---

至此结束。

Standalone 模式一般用来测试，事实上也是可以生产使用，更多配置信息见：[https://spark.apache.org/docs/latest/spark-standalone.html#launching-spark-applications](https://spark.apache.org/docs/latest/spark-standalone.html#launching-spark-applications)。
