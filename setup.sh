#!/bin/sh


if [ ! -e vagrant/files/ssh_key_dsa ] ; then
    echo Generating ssh keys
    ssh-keygen -t dsa -P '' -f vagrant/files/ssh_key_dsa
else
    echo SSH Keys already generated
fi


#Set up hadoop locally
if [ ! -e hadoop ] ; then
    echo Setting up local instance of Hadoop
    if [ ! -e vagrant/files/hadoop-2.5.2.tar.gz ] ; then
        wget -q -P vagrant/files/ http://mirror.ox.ac.uk/sites/rsync.apache.org/hadoop/common/hadoop-2.5.2/hadoop-2.5.2.tar.gz
    fi

    tar xzf vagrant/files/hadoop-2.5.2.tar.gz
    ln -s hadoop-2.5.2 hadoop

    echo Setting up configuration
    cp -v vagrant/files/hadoop/etc/hadoop/* hadoop/etc/hadoop/
    sed -i.bak 's/master.hadoop/localhost/g' hadoop/etc/hadoop/*
else
    echo Hadoop local instace already installed
fi

echo -e "\n\n"
echo 'Run the following command to add the Hadoop bin folder to the path'
echo "  export PATH=`pwd`/hadoop/bin:\$PATH"
