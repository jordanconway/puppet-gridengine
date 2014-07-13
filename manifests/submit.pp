class gridengine::submit {

include gridengine, nfs-client::home, nis

    package { "gridengine-qmon":
        ensure => installed,
        require => Class['yumrepos']
    }

    exec { "add_submit_host":
        user => sgeadmin,
        group => sgeadmin,
        environment => "SGE_ROOT=/usr/share/gridengine",
        command => "/usr/bin/ssh -i /usr/share/gridengine/id_rsa.gridengine sgeadmin@gridmaster.DOMAIN.com \"/usr/bin/qconf -as ${hostname}\"",
        refreshonly => true,
        onlyif => "/usr/bin/test \"`/usr/bin/qconf -ss|grep $hostname`\" != \"$hostname.DOMAIN.com\"",
        require => [File['/usr/share/gridengine/.ssh/known_hosts'],File['/usr/share/gridengine/id_rsa.gridengine']],
    }

}
