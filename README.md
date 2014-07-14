puppet-gridengine
=================

Puppet module to configure gridengine master, submit host and processing nodes.

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
