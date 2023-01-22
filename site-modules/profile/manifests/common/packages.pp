# @summary Install set of packages everywhere
#
# Package list is set in the module's Hiera depending on the OS
#
# @param ensure
#   Controls the resources presence
# @param versions
#   Hash of packages to manage (package name => package ensure)
class profile::common::packages (
  Profile::Ensure $ensure = 'present',
  Hash[String[1], String[1]] $versions = {},
) {
  $versions.each |$pkg, $ens| {
    $real_ensure = $ensure ? {
      'absent' => 'absent',
      default  => $ens,
    }
    package { $pkg:
      ensure => $real_ensure,
    }
  }
}
