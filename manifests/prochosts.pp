class gridengine::prochosts {

include gridengine

# Only modify $prochosts and $prochostslots
# $prochosts is an array of processing VMs
$prochosts = ["vm1.DOMAIN.com","vm2.DOMAIN.com","vm3.DOMAIN.com"]

# $prochostslot is the number of processing slots on each host 
# (in the future this should probably be different for each host, use a 2d-array of host,slot )
$prochostslot = "4"

# $slotcount is the total number of processing slots it does NOT need to be modified
$slotcount = inline_template("<%= (@prochosts.length * Integer(@prochostslot)).to_s() %>")

    file { "/usr/share/gridengine/short.q":
        ensure => present,
        content => template("gridengine/short.erb"),
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => Package['gridengine']
    }

    file { "/usr/share/gridengine/medium.q":
        ensure => present,
        content => template("gridengine/medium.erb"),
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => Package['gridengine']
    }

    file { "/usr/share/gridengine/long.q":
        ensure => present,
        content => template("gridengine/long.erb"),
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => Package['gridengine']
    }

    file { "/usr/share/gridengine/hostgroups":
        ensure => present,
        content => template("gridengine/hostgroups.erb"),
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => Package['gridengine']
    }

    exec {'addadminhost':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        command => "/usr/bin/ssh -i /usr/share/gridengine/id_rsa.gridengin sgeadmin@gridmaster.DOMAIN.com \"/usr/bin/qconf -ah ${hostname}\"",
        onlyif => "/usr/bin/test \"`/usr/bin/qconf -sh|grep $hostname`\" != \"$hostname.DOMAIN.com\"",
        require => [File['/usr/share/gridengine/.ssh/known_hosts'],File['/usr/share/gridengine/id_rsa.gridengine']],
    }

    exec {'/usr/bin/qconf -Mq /usr/share/gridengine/short.q':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        subscribe => File['/usr/share/gridengine/short.q'],
        refreshonly => true,
        require => Exec['addadminhost']
    }

    exec {'/usr/bin/qconf -Mq /usr/share/gridengine/medium.q':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        subscribe => File['/usr/share/gridengine/medium.q'],
        refreshonly => true,
        require => Exec['addadminhost']
    }

    exec {'/usr/bin/qconf -Mq /usr/share/gridengine/long.q':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        subscribe => File['/usr/share/gridengine/long.q'],
        refreshonly => true,
        require => Exec['addadminhost']
    }

    exec {'/usr/bin/qconf -Mhgrp /usr/share/gridengine/hostgroups':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        subscribe => File['/usr/share/gridengine/hostgroups'],
        refreshonly => true,
        require => [Exec['/usr/bin/qconf -Mq /usr/share/gridengine/short.q'],Exec['/usr/bin/qconf -Mq /usr/share/gridengine/medium.q'],Exec['/usr/bin/qconf -Mq /usr/share/gridengine/long.q']],
        notify => Service["sge_execd"]
    }

}
