# @summary Manage genders
#
# @example
#   include ::genders
#
# @param manage_repo
#   Boolean that sets of repo for genders should be managed
#   Currently only impacts Red Hat based systems
# @param package_name
#   Genders package name
# @param package_ensure
#   Genders package ensure property
# @param nodeattr_path
#   Path to nodeattr command, used when verifying genders file
# @param config_path
#   Path to genders file
# @param verify_config
#   Boolean that sets of genders file should be verified before changes are made
#   The verify requires a second copy of genders file be created
# @param nodes
#   Hash used to define genders::node resources.
#
class genders (
  Boolean $manage_repo = true,
  String $package_name = 'genders',
  String $package_ensure = 'installed',
  String $nodeattr_path = 'nodeattr',
  Stdlib::Absolutepath $config_path = '/etc/genders',
  Boolean $verify_config = true,
  Hash $nodes = {},
) {

  if dig($facts, 'os', 'family') == 'RedHat' {
    if $manage_repo {
      include ::epel
      $package_require = Yumrepo['epel']
    } else {
      $package_require = undef
    }
  } else {
    $package_require = undef
  }

  package { 'genders':
    ensure  => $package_ensure,
    name    => $package_name,
    require => $package_require,
  }

  if $verify_config {
    $concat_path = "${config_path}.puppet"
    $concat_notify = Exec['verify-genders']
    exec { 'verify-genders':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => "${nodeattr_path} -f ${concat_path} -k",
      refreshonly => true,
      logoutput   => true,
    }
    file { '/etc/genders':
      ensure  => 'file',
      path    => $config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $concat_path,
      require => Exec['verify-genders'],
    }
  } else {
    $concat_path = $config_path
    $concat_notify = undef
  }

  concat { '/etc/genders':
    ensure  => 'present',
    path    => $concat_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['genders'],
    notify  => $concat_notify,
  }

  concat::fragment { '/etc/genders.header':
    target  => '/etc/genders',
    content => "# File managed by Puppet\n",
    order   => '01',
  }

  $nodes.each |$name, $node| {
    genders::node { $name: * => $node }
  }

}