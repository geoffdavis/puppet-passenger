class passenger::install {
  case $::operatingsystem {
    solaris: { include passenger::install::solaris }
    default: { fail('Invalid operating system $::operatingsystem for passenger') }
  }
}
