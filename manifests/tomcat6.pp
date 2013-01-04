class tomcat::tomcat6 {
  include file_transporter

  package { "tomcat6": ensure => installed }
  package { "tomcat6-admin": ensure => installed }

  exec { "restart tomcat6":
    command     => "/etc/init.d/tomcat6 restart",
    require     => Package['tomcat6'],
    refreshonly => true,
  }

  file { "/etc/tomcat6":
    ensure  => directory,
    recurse => true,
    force   => true,
    mode  => 0644,
    owner   => root,
    group   => tomcat6,
    source  => only_existing_sources([
      "/vagrant/files/${module_name}/etc/tomcat6",
      "puppet:///modules/${module_name}/etc/tomcat6"
    ]),
    sourceselect => 'all',
    require      => Package['tomcat6'],
    notify       => Exec["restart tomcat6"]
  }

  exec { "chmod -R 775 /var/cache/tomcat6":
    require => Package['tomcat6'],
  }

  exec { "chmod -R 774 /var/log/tomcat6/":
    require => Package['tomcat6'],
  }

  # the below is required on Ubuntu, as CATALINA_HOME and CATALINA_BASE have been separated
  exec { "ln -s /var/lib/tomcat6/conf /usr/share/tomcat6/conf":
    require => Package['tomcat6'],
    creates => '/usr/share/tomcat6/conf',
  }

  exec { "ln -s /etc/tomcat6/policy.d/03catalina.policy /usr/share/tomcat6/conf/catalina.policy":
    require => Exec['ln -s /var/lib/tomcat6/conf /usr/share/tomcat6/conf'],
    creates => '/usr/share/tomcat6/conf/catalina.policy',
  }

  exec { "ln -s /var/lib/tomcat6/webapps /usr/share/tomcat6/webapps":
    require => Package['tomcat6'],
    creates => '/usr/share/tomcat6/webapps',
  }

  exec { "ln -s /var/log/tomcat6 /usr/share/tomcat6/logs":
    require => Package['tomcat6'],
    creates => '/usr/share/tomcat6/logs',
  }

  exec { "ln -s /var/cache/tomcat6 /usr/share/tomcat6/work":
    require => Package['tomcat6'],
    creates => '/usr/share/tomcat6/work',
  }

  exec { "mkdir /var/tmp/tomcat6 && ln -s /var/tmp/tomcat6 /usr/share/tomcat6/temp":
    require => Package['tomcat6'],
    creates => '/usr/share/tomcat6/temp',
  }
}