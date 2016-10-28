#!/bin/bash

service sshd start >> /dev/null
HADOOP_PREFIX=/usr/local/hadoop
NAMENODE_DIR=/namenode
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
#cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/NAMENODE_HOSTNAME/$NAMENODE_HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
# format and hdfs namenode
if [ "$NODE_ROLE" = "hdfs" ]; then
   if [ -z "$HDFS_ROLE" -o  "$HDFS_ROLE" = "namenode" ]; then
        if [ ! -f "$NAMENODE_DIR/format" ] ; then
           echo "format namenode"
           $HADOOP_PREFIX/bin/hdfs namenode -format
	       touch "$NAMENODE_DIR/format"
        fi
        echo "start namenode"
       $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
    fi

    if [ -z "$HDFS_ROLE" -o "$HDFS_ROLE" = "datanode" ]; then
       echo "start datanode"
       $HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
    fi
fi

# start yarn
if [ "$NODE_ROLE" = "yarn" ];then
   sed s/RESOURCEMANAGE_HOSTNAME/$RESOURCEMANAGE_HOSTNAME/ /usr/local/hadoop/etc/hadoop/yarn-site.xml.template > /usr/local/hadoop/etc/hadoop/yarn-site.xml
   # add hdfs info
   echo -e $HDFSINFO >> /etc/hosts
   #add yar slaves info
   echo -e $SLAVES >> /usr/local/hadoop/etc/hadoop/slaves
   $HADOOP_PREFIX/sbin/start-yarn.sh
   #$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver 
fi


while true; do sleep 1000; done


#$HADOOP_PREFIX/sbin/start-dfs.sh


if [ "$1" = "-d" ] ; then
  while true; do sleep 1000; done
fi

if  [ "$1" = "-bash" ] ; then
  /bin/bash
fi
