#Hadoop sandbox on Vagrant

For now this starts a master node (master.hadoop) and one slave (slave1.hadoop). Hopefully soon the number of slaves will be a configuration property. The master box exposes the ports 50070, 19888 and 8088. The slave boxes don't expose any ports (apart from the ssh port). The boxes talk to eachother over a private network (192.168.44.0)

Each box has 4 cores, 4GB of RAM and 40GB of disk. The storage can be increased with extra disks, but it's already quite a bit of storage for a sandbox.

## How to run
1. You first need to generate a group of keys by running [complete], hadoop will use this to ssh between the boxes
2. run `vagrant up`
3. ssh to the master box and run `start_master.sh`
4. ssh to each to the slaves and run `start_slave.sh`

All of this will be automated in the future... but for now, that's how it's :).

After this you should be able to access the web console on [http://localhost:50070](http://localhost:50070), and see one datanode


###TODO
1. Script to untar and configure hadoop on the host machine (copy core-site and hdfs-site conf files)
2. Generate ssh keys

