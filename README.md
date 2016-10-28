###部署HDFS NameNode节点：

docker run -itd --restart=always --env NAMENODE_HOSTNAME=master.iop.com -v /datanode:/datanode --net=host 10.110.17.138:5000/wangdk/hdfs:v0.5 /usr/local/bin/start.sh

###部署HDFS DataNode节点

docker run -itd --restart=always --env NAMENODE_HOSTNAME=master.iop.com -v /datanode:/datanode --net=host --env HDFS_ROLE=datanode 10.110.17.138:5000/wangdk/hdfs:v0.5 /usr/local/bin/start.sh


####K8s部署Yarn集群

kubectl create -f config.yaml  
kubectl create -f yarn-petset.yaml 

