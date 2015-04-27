#Hadoop sandbox on Vagrant

## Why Vagrant?

Why *Vagrant* you might ask? Why not Docker? Well, I've never used a multi-box setup with Vagrant and I thought it would be a nice experiment.

## What's in the tin?

For now this starts a master node (master.hadoop) and one slave (slave1.hadoop). Hopefully soon the number of slaves will be a configuration property. The master box exposes the ports 50070, 19888 and 8088. The slave boxes don't expose any ports (apart from the ssh port). The boxes talk to eachother over a private network (192.168.44.0)

Each box has 4 cores, 4GB of RAM and 40GB of disk. The storage can be increased with extra disks, but it's already quite a bit of storage for a sandbox.

## Requirements

* A good cup of coffee
* Virtual Box (tested on 4.3.20).
* Vagrant (tested on 1.7.1).
* A Linux variant or osx (this might work on cygwin).
* A PC with +12GB of RAM for one master and one slave. Add 4GB per extra slave.

## How to run
1. Run `setup.sh`. This will create a set of ssh keys to allow Hadoop to ssh to the slaves. This will also create a local instalation of Hadoop (to allow you copy files via hdfs)
2. run `vagrant up`
3. (on the first run) ssh to the master box and format the hdfs with the command `hdfs namenode -format`.
4. ssh to the master box and run `start_master.sh`
5. ssh to each to the slaves and run `start_slave.sh`

The startup will be automated in the future, but for now it's manual :).

After this you should be able to access the web console on [http://localhost:50070](http://localhost:50070), and see one datanode

## Hadoop examples
The code of the examples is taken from the great book Pro Apache Hadoop by Sameer Wadkar and Madhu Siddalingaiah (ISBN 978-1-4302-4863-7).

###TODO
1. Create startup scripts for the master and slaves.
2. Make setup scripts a bit more generic.
3. Add a small map reduce job as an example.
