class passenger::install::solaris {
  include passenger::params

  # Install the CSW dependencies for the build
  package { 'rubygems':    provider => pkgutil, ensure => installed, }
  package { 'ruby18_dev':  provider => pkgutil, ensure => installed, }
  package { 'libidn_dev':  provider => pkgutil, ensure => installed, }
  package { 'libcurl_dev': provider => pkgutil, ensure => installed, }
  package { 'gcc4g++':    provider => pkgutil, ensure => installed, }
  package { 'ruby18_gcc4': provider => pkgutil, ensure => installed, }
  package { 'apache2_dev': provider => pkgutil, ensure => installed, }

  # Install the ruby gems
  package { 'rack':
    provider => gem,
    ensure   => $passenger::params::rack_version,
    require  => Package['rubygems'],
  }
  package { 'passenger':
    provider => gem,
    ensure   => $passenger::params::passenger_version,
    require  => Package['rubygems'],
  }

  # Patch the compiler options for Solaris with OpenCSW
  file { 'passenger/compiler.rb':
    path   => "${passenger::params::passenger_gemdir}/lib/phusion_passenger/platform_info/compiler.rb",
    source => "puppet:///modules/passenger/compiler_${passenger::params::passenger_version}.rb",
    owner  => 'root',
    group  => 'root',
  }

  # Install the apache2 module
  exec { 'passenger-install-apache2-module':
    command => '/opt/csw/bin/passenger-install-apache2-module \
                --apxs2-path /opt/csw/apache2/sbin/apxs --auto',
    path    => [ '/opt/csw/bin', '/usr/bin', '/usr/ccs/bin' ],
    creates => "${passenger::params::passenger_gemdir}/ext/apache2/mod_passenger.so",
    require => [
      Package['libidn_dev'],
      Package['libcurl_dev'],
      Package['apache2_dev'],
      File['passenger/compiler.rb'],
    ],
  }
}
