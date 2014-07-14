puppet-gridengine
=================

Puppet module to configure gridengine master, submit host and processing nodes.

##Manifests

###master.pp
This will setup your gridengine master for scheduling and job distribution.

###newhost.pp
This will setup one processing host with an independant (non-clustered) processing queue.

###prochost.pp
This module is used on any clustered processing hosts. You need to define the hostnames in $prochosts and the number of processing slots in $prochostslot

###submit.pp
In this configuration, there is a shared submit host with nfs mounted home directories and NIS authentication, users log into this host to sumbit jobs for processing on the prochosts.

###legacy.pp 
This uses a custom built rpm of an older version of Sun GridEngine to allow compatibility and shared queues with legacy Redhat 7.3 and Debian 3.0 processing hosts. It is useless to anyone else.

## Files
###gridengine/gridengine.conf
You should set your ADMIN_MAIL here

###keys/id_rsa.gridengine
This is a passwordless private key to allow ssh commands between master and prochosts. You'll need to generate your own, it should only be used for this. Keep it protected as you would any key.

###ssh/authorized_keys
This contains the public key for the above private key

###ssh/known_hosts
This is the known_hosts entry for your gridmaster

##Templates
###hostgroups.erb
No need for modification, it tells gridengine your prochosts based on prochost.pp variables

###long/medium/short.erb
The templates define your gridengine queues, there is a long, medium and short queue. You can configure any gridengine queue variables here, such as time, load etc. 

###newhost.erb 
As above it is a definition of your gridengine queue, but for the standalone newhost.pp
