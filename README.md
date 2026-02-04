# puppet-module-genders

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/genders.svg)](https://forge.puppetlabs.com/treydock/genders)
[![Build Status](https://travis-ci.org/treydock/puppet-module-genders.png)](https://travis-ci.org/treydock/puppet-module-genders)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with genders](#setup)
    * [What genders affects](#what-genders-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - Module reference](#reference)

## Description

This module will manage [genders](https://github.com/chaos/genders)

## Setup

### What genders affects

This module will install the genders packages and manage the genders config.

## Usage

Install genders:

```puppet
include ::genders
```

Define nodes either via `genders` class parameter or via defined type:

```puppet
class { '::genders':
  nodes => {
    'compute01' => { 'attrs' => ['compute','rack01'] },
  },
}
::genders::node { 'compute02':
  attrs => ['compute','rack01'],
}
```

A node's attributes can be defined as a Hash

```puppet
::genders::node { 'compute02':
  attrs => {'role' => 'compute','rack' => 'rack01'},
}
```

A node can be defined as an Array

```puppet
::genders::node { 'compute':
  node => ['compute01','compute02']
  attrs => ['compute','rack01'],
}
```

## Reference

[http://treydock.github.io/puppet-module-genders/](http://treydock.github.io/puppet-module-genders/)
