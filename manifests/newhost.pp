# Adds any host as a processing node with 1 unlimited queue named after it's hostname
class gridengine::newhost {

include gridengine

    file { "/usr/share/gridengine/$hostname.long.q":
        ensure => present,
        content => template("gridengine/newhost.erb"),
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => Package['gridengine']
    }

    exec {'addadminhost':
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        command => "/usr/bin/ssh -i /usr/share/gridengine/id_rsa.gridengine sgeadmin@gridmaster.DOMAIN.com \"/usr/bin/qconf -ah ${hostname}\"",
        onlyif => "/usr/bin/test \"`/usr/bin/qconf -sh|grep $hostname`\" != \"$hostname.DOMAIN.com\"",
        require => [File['/usr/share/gridengine/.ssh/known_hosts'],File['/usr/share/gridengine/id_rsa.gridengine']],
    }

    exec { "add_queue":
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        command => "/usr/bin/qconf -Aq /usr/share/gridengine/$hostname.long.q",
        subscribe => File["/usr/share/gridengine/$hostname.long.q"],
        refreshonly => true,
        onlyif => "/usr/bin/test \"`/usr/bin/qconf -sql|grep $hostname`\" != \"$hostname.long.q\"",
        notify => Service['sge_execd']
    }

    exec { "modify_queue":
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        command => "/usr/bin/qconf -Mq /usr/share/gridengine/$hostname.long.q",
        subscribe => File["/usr/share/gridengine/$hostname.long.q"],
        refreshonly => true,
        onlyif => "/usr/bin/test \"`/usr/bin/qconf -sql|grep $hostname`\" = \"$hostname.long.q\"",
        notify => Service['sge_execd']
    }

    Exec["modify_queue"] -> Exec["add_queue"]
}
