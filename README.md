# ourCluster
private person use

linux密码： 

​		root 	Root123456..

​		root 	Root123456..

​	zhanghoumin	Abc123456..

​	hadoop101/102: weichuanfu	Abc123456..

软件包放置目录: /app/installPackage 软件安装目录： /app/software

账户：密码 mysql : -uroot -p'aS,j6hwQrP+D'

MySQL     账户：maxwell	 密码：	Abc234!#34#%kh

-----------------------------------------------------------------------------------------------------------------------------

日志位置 ：

​	start: 	/opt/data/mock/start

​	other:	/opt/data/mock/other

​	error:	/opt/data/mock/error

------------------------------------------------------------------------------------------------------------------------------------------

kafka  topics：

​	BD_ODS_DB_GMALL2020： mysql导入到kafka的数据

​	

-------------------------------------------------------------------------------------------------------------------------------------------

实时集群 使用流程

​	①启动脚本	zhm_all_cluster.sh	start

​						   zhm_webserver.sh	start

​	②发送请求	

​			修改mock用户行为日志和业务数据的      日期

​			用户日志：ssh hadoop101 	java -jar	/opt/mock/online/mock-log/gmall2020-mock-log-2020-05-10.jar

​			业务数据：ssh hadoop101 	java -jar	/opt/mock/online/mock-log/gmall2020-mock-db-2020-05-18.jar
