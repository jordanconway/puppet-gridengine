class gridengine {

    package { "gridengine":
        ensure => installed,
        require => Class['yumrepos']
    }

    package { "gridengine-execd":
        ensure => installed,
        require => Class['yumrepos']
    }

    package { "gridengine-qmaster":
        ensure => installed,
        require => Class['yumrepos']
    }

    package { "mailx":
        ensure => installed,
        require => Class['yumrepos']
    }

    # do not run on gridmaster or gridsubmit"
    if $hostname !~ /^grid/ {
        service { "sge_execd":
            ensure => running,
            enable => true,
            hasstatus => true,
            hasrestart => true,
            require => [Package['gridengine'],Package['gridengine-execd'],Package['gridengine-qmaster'],Exec['setsgeroot']]
        }
    }

    else {
        service { "sge_execd":
            ensure => stopped,
            enable => false,
        }
    }

    file { "/usr/share/gridengine/gridengine.conf":
        ensure => present,
        source => "puppet://$puppetserver/modules/gridengine/gridengine/gridengine.conf",
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => [Package['gridengine'],Package['gridengine-execd'],Package['gridengine-qmaster']]
    }

    file { "/usr/share/gridengine/default":
        ensure => directory,
        recurse => true,
        source => "puppet://$puppetserver/modules/gridengine/default",
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0644,
        require => [Package['gridengine'],Package['gridengine-execd'],Package['gridengine-qmaster']]
    }

    exec {'setsgeroot':
        command => 'export SGE_ROOT=/usr/share/gridengine',
        provider => shell,
        subscribe => File['/usr/share/gridengine/gridengine.conf'],
        onlyif => "/usr/bin/test `echo $SGE_ROOT` != /usr/share/gridengine",
    }

    file { "/usr/share/gridengine/id_rsa.gridengine":
        ensure => present,
        source => "puppet://$puppetserver/modules/gridengine/keys/id_rsa.gridengine",
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0600,
        require => Package['gridengine']
    }

    exec  { "/bin/mkdir -p -m0700 /usr/share/gridengine/.ssh":
        user => sgeadmin,
        group => sgeadmin,
        creates => "/usr/share/gridengine/.ssh",
        require => Package['gridengine']
    }

    file { "/usr/share/gridengine/.ssh/known_hosts":
        ensure => present,
        source => "puppet://$puppetserver/modules/gridengine/ssh/known_hosts",
        owner => sgeadmin,
        group => sgeadmin,
        mode => 0600,
        require => Exec['/bin/mkdir -p -m0700 /usr/share/gridengine/.ssh']
    }
}
