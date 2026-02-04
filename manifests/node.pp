# @summary Manage genders node
#
# @example Define nodes
#   genders::node { 'compute01':
#     attrs => ['compute','rack01'],
#   }
#
# @example Define node with Hash attrs
#   genders::node { 'compute01':
#     attrs => { 'class' => 'compute', 'rack' => 'rack01' },
#   }
#
# @param node
#   The node or nodes to define in genders file
# @param attrs
#   Array or Hash of attributes to define for a node
# @param content
#   Optional content to override module template
# @param source
#   Optional Source to override module template
# @param order
#   Order in genders file for this node
#
define genders::node (
  Variant[Array[String], String] $node = $name,
  Variant[Array[String],Hash[String,String]] $attrs = [],
  Optional[String] $content = undef,
  Optional[String] $source = undef,
  String $order = '50',
) {
  include genders

  if ! $source and ! $content {
    $_content = template('genders/node.erb')
  } else {
    $_content = $content
  }

  concat::fragment { "/etc/genders.${name}":
    target  => '/etc/genders',
    content => $_content,
    source  => $source,
    order   => $order,
  }
}
