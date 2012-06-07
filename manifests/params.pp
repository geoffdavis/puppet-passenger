class passenger::params {
  $passenger_version  = '3.0.11'
  $rack_version       = '1.4.1'

  $gem_basedir = $::operatingsystem ? {
    solaris => '/opt/csw/lib/ruby/gems/1.8/gems',
    default => undef,
  }

  $passenger_gemdir = "${gem_basedir}/passenger-${passenger_version}"
}
