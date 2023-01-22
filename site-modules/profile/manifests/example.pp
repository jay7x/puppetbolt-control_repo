# @summary Example profile

# @param ensure
#   Controls the resources presence
class profile::example (
  Profile::Ensure $ensure = 'present',
) {
  $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }
  file { '/tmp/example.txt':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => 'Hello world',
  }
}
