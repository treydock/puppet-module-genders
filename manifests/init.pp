# @summary Manage genders
#
# @example
#   include genders
#
# @param manage_repo
#   Boolean that sets of repo for genders should be managed
#   Currently only impacts Red Hat based systems
# @param package_name
#   Genders package name
# @param package_ensure
#   Genders package ensure property
# @param config_path
#   Path to genders file
# @param nodes
#   Hash used to define genders::node resources.
#
class genders (
  Boolean $manage_repo = true,
  String $package_name = 'genders',
  String $package_ensure = 'installed',
  Stdlib::Absolutepath $config_path = '/etc/genders',
  Hash $nodes = {},
) {

  if dig($facts, 'os', 'family') == 'RedHat' {
    if $manage_repo {
      include epel
      Yumrepo['epel'] -> Package['genders']
    }
  }

  package { 'genders':
    ensure => $package_ensure,
    name   => $package_name,
  }

  concat { '/etc/genders':
    ensure       => 'present',
    path         => $config_path,
    owner        => 'root',
    group        => 'root',
    mode         => '0644',
    validate_cmd => 'nodeattr -f % -k',
    require      => Package['genders'],
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