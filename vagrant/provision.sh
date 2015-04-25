#!/bin/bash

EXECUTION_MARK_FOLDER=/usr/local/mark

mkdir -p ${EXECUTION_MARK_FOLDER}

# Marks a given task as executed by creating a file.
function markExecuted {
  touch ${EXECUTION_MARK_FOLDER}/$1
  echo Marked executed $1
}

# Checks that a given task has been completed if a given file exists.
function hasExecuted {
  return `[ -f ${EXECUTION_MARK_FOLDER}/$1 ]`
}


STAGE=disable_ipv6
if ! hasExecuted $STAGE; then
  echo '# disable ipv6' >> /etc/sysctl.conf
  echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
  echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
  echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
  echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
  markExecuted $STAGE
fi

STAGE=installEpel
if ! hasExecuted $STAGE; then
  rpm --import http://ftp.riken.jp/Linux/fedora/epel/RPM-GPG-KEY-EPEL-6 && \
  rpm -Uvh --quiet http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  markExecuted $STAGE
fi

STAGE=installBasePackages
if ! hasExecuted $STAGE; then
  yum install -y man vim rsync
  markExecuted $STAGE
fi

STAGE=installJava
if ! hasExecuted $STAGE; then
  yum install -y java-1.8.0-openjdk-devel
  echo "export JAVA_HOME=/usr/lib/jvm/java" >> /home/vagrant/.bashrc
  markExecuted $STAGE
fi

STAGE=sshKeyConfig
if ! hasExecuted $STAGE; then
  cp /vagrant/files/ssh_key_dsa /home/vagrant/.ssh/id_dsa
  chmod 400 /home/vagrant/.ssh/id_dsa

  cat /vagrant/files/ssh_key_dsa.pub >> /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant/.ssh

  markExecuted $STAGE
fi


STAGE=dnsMasq
if ! hasExecuted $STAGE; then
  cp /vagrant/files/hosts /etc/hosts
  #yum install -y dnsmasq
  #service dnsmasq start
  #chkconfig dnsmasq on
  markExecuted $STAGE
fi


STAGE=installHadoop
if ! hasExecuted $STAGE; then
  cd /home/vagrant
  if [ ! -e /vagrant/files/hadoop-2.5.2.tar.gz ] ; then
    wget -q -P /vagrant/files/ http://mirror.ox.ac.uk/sites/rsync.apache.org/hadoop/common/hadoop-2.5.2/hadoop-2.5.2.tar.gz
  fi
  tar xzf /vagrant/files/hadoop-2.5.2.tar.gz
  ln -s hadoop-2.5.2 hadoop

  echo 'export HADOOP_PREFIX=/home/vagrant/hadoop' >> /home/vagrant/.bashrc
  echo 'export HADOOP_YARN_HOME=$HADOOP_PREFIX' >> /home/vagrant/.bashrc
  echo 'export HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop' >> /home/vagrant/.bashrc
  echo 'export PATH=$PATH:$HADOOP_PREFIX/bin' >> /home/vagrant/.bashrc
  cp /vagrant/files/hadoop/etc/hadoop/* /home/vagrant/hadoop/etc/hadoop/
  chown -R vagrant:vagrant hadoop-2.5.2
  cd -

  mkdir /home/vagrant/bin
  cp /vagrant/files/bin/* /home/vagrant/bin
  chown -R vagrant:vagrant /home/vagrant/bin

  # need to format hdfs before starting the name node 
  # $HADOOP_PREFIX/bin/hdfs namenode -format

  markExecuted $STAGE
fi

# yum cleanup
