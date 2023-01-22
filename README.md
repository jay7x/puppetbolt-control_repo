# PDK-managed Puppet-Bolt-driven control repo skeleton

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Quick Start](#quick-start)
1. [Advanced Usage](#advanced-usage)

## Description

This repository contains an Puppet control repository skeleton to be used with [Puppet Bolt](https://www.puppet.com/docs/bolt/latest/bolt.html). It resembles usual [control repo structure](https://github.com/puppetlabs/control-repo) with some additions. E.g. it uses [PDK](https://www.puppet.com/docs/pdk/2.x/pdk.html) for validation and unit tests and [Beaker](https://github.com/voxpupuli/beaker) for acceptance tests.

Idea is to use this repository as a starting point to be adopted for your needs.

## Setup

To use this repository you need the following:

1. Working `git` setup
1. [Puppet Bolt](https://www.puppet.com/docs/bolt/latest/bolt.html)
1. [PDK](https://www.puppet.com/docs/pdk/2.x/pdk.html)

## Quick start

1. Clone the repository:

   ```text
   git clone git@github.com:jay7x/puppetbolt-control_repo.git
   ```

1. Create the [Bolt inventory](https://www.puppet.com/docs/bolt/latest/inventory_files.html) for your infrastructure. You may want to use [inventory plugins](https://www.puppet.com/docs/bolt/latest/supported_plugins.html) (called "reference plugins" as well) for dynamic inventory targets when using Terraform or AWS e.g.

1. Classify (i.e. map) your nodes to Puppet roles. Currently Hiera classifier is implemented in this repo. To attach a role to the node you should create the node-specific file in Hiera (`data/nodes/<hostname>.yaml`) and set the value of the key `hiera_classifier::pp_role` to your desired role name (w/o `role::` prefix). See the example file `data/nodes/example1.yaml` as a reference.

   ```yaml
   ---
   hiera_classifier::pp_role: example
   ```

   This classifies the `example1` host to the `role::example` role.

   NOTE: This is not really useful in dynamic hostnames environment though.. so maybe some other classifier should be implemented for the case.

1. Implement your profiles under `site-modules/profile/manifests`.

1. Define your roles under `site-modules/role/manifests`.

1. Write unit tests for your classes and defined resources under `spec/classes` and `spec/defines`. You may consider writing tests for your hosts under `spec/hosts` as well (note those tests are checking just the Puppet catalog compiled not the runtime status)

1. Ensure your code is valid and follows best practices with `pdk validate`

1. Ensure your unit tests are good with `pdk test unit`

1. One can implement acceptance tests too. To do this you should define nodeset file under `spec/acceptance/nodesets` and then write your serverspec/beaker-rspec spec under `spec/acceptance`. Then you can check if your acceptance tests are good with `pdk bundle exec rake beaker:all`. Though it's not that easy usually so this part should be explained better with time.

1. Apply your manifests finally! There are two commands. Feel free to choose one you'd like more:

   ```bash
   bolt plan run control_repo::apply -t <comma,separated,targets,list> [noop=true]
   # - OR -
   bolt apply manifests/site.pp -t <comma,separated,targets,list> [--noop]
   ```

   This will apply your classified roles to the target list given in `-t` (or `--targets`) option. Use `-t all` to apply everywhere.

## Advanced usage

### Hiera classifier

... to be written...

### Unit tests

... to be written...

### Acceptance tests

... to be written...
