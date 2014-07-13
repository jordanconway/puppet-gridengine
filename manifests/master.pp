#ssh stuff should be put into it's own module probably
class gridengine::master {

    include gridengine

    package { "gridengine-qmon":
        ensure => installed,
        require => Class['yumrepos']
    }

    service { "sgemaster":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
        require => [Package['gridengine'],Package['gridengine-execd'],Package['gridengine-qmaster']]
    }

    file { "/usr/share/gridengine/.ssh":
        ensure => directory,
        source => "puppet://$puppetserver/modules/gridengine/ssh",
        owner => sgeadmin,
        group => sgeadmin,
        purge => true,
        recurse => true,
        mode => 0600
    }

    line {"ssh config":
        file => '/etc/ssh/sshd_config',
        line => 'PasswordAuthentication yes',
        notify => Service['sshd'],
    }
 
}
