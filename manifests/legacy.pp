class gridengine::legacy {
    
    package { "sge-legacy-6.1u2":
        ensure => latest,
        require => Class['yumrepos']
    }

    service { "sgeexecd":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
        require => Package['sge-legacy-6.1u2']
    }
}
