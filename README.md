# PDK-managed Puppet-Bolt-driven control repo skeleton

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Quick Start](#quick-start)
1. [Advanced Usage](#advanced-usage)

## Description

This repository contains an Puppet control repository skeleton to be used with [Puppet Bolt](https://www.puppet.com/docs/bolt/latest/bolt.html). It resembles usual [control repo structure](https://github.com/puppetlabs/control-repo) with some additions. E.g. it uses [PDK](https://www.puppet.com/docs/pdk/2.x/pdk.html) for validation and unit tests and [Beaker](https://github.com/voxpupuli/beaker) for acceptance tests.

Goals of creating this repository is to show the following:

1. How to use PDK to manage a Puppet control repo.
1. How to manage Puppet modules with Puppet Bolt.
1. How to enable and how to write unit tests for Puppet catalog entries.
1. How to enable and how to write acceptance tests for Puppet roles.
1. How to use Hiera for node classification.

Why this repository is organized in this specific way? There are reasons:

1. Main point is to be able to `run bolt plan run control_repo::apply` to apply on every agent with its correct role. I.e. you don't need to keep the `agent` -> `role` mapping in your head. This allows to do `hosts` (see `spec/hosts`) unit testing and node acceptance testing as well because Puppet knows which role is assigned to the node.
1. Another point is to keep the repo structure as close to an usual control repo as possible. I.e. you should be able to drop this repo into an environment directory and your puppet server can deal with it. Though this point is not a hard requirement here.
1. Goals above require things to be organized in a specific way too.

Note that big infrastructures with over than 100 servers are out of this repo scope. I'd say one shouldn't use push model for big infra.

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

### Directory structure

```text
├── .devcontainer                     # PDK: vscode devcontainer settings
│   ├── Dockerfile
│   ├── README.md
│   └── devcontainer.json
├── .editorconfig                     # See https://editorconfig.org/
├── .fixtures.yml                     # PDK: fixtures config
├── .gitattributes                    # PDK: git attributes config
├── .gitignore                        # PDK: files to ignore in git
├── .gitlab-ci.yml                    # PDK: Gitlab CI config
├── .pdkignore                        # PDK: files to ignore in module tarball
├── .puppet-lint.rc                   # PDK: puppet-lint config
├── .rspec                            # PDK: rspec config
├── .rubocop.yml                      # PDK: rubocop config
├── .sync.yml                         # PDK: pdk-templates config
├── .travis.yml                       # PDK: Travis CI config
├── .vscode                           # PDK: VSCode config
│   └── extensions.json
├── .yardopts                         # PDK: YARD config (puppet strings)
├── CHANGELOG.md                      # PDK: ChangeLog template
├── Gemfile                           # PDK: Gemfile
├── LICENSE                           # Apache 2.0 License text
├── README.md                         # This README
├── Rakefile                          # PDK: Rake config
├── appveyor.yml                      # PDK: AppVeyor CI config
├── bolt-project.yaml                 # Bolt: main Bolt config
├── data                              # Hiera data directory
│   ├── common.yaml                   # Common Hiera data goes here
│   └── nodes                         # Per-node Hiera data goes here
│       └── example1.yaml             # Hiera data for the `example1` host
├── environment.conf                  # Puppet environment config
├── hiera.yaml                        # Hiera's hierarchy definition
├── manifests
│   └── site.pp                       # The "main" manifest (Puppet entry-point)
├── metadata.json                     # PDK: Puppet module metadata
├── pdk.yaml                          # PDK: PDK config
├── plans                             # Bolt: plans goes here
│   └── apply.pp                      # Puppet Bolt plan to apply your manifests
├── rakelib
│   └── beaker-all.rake               # Rake task to run acceptance tests for every node
├── site-modules                      # Place to store your local modules
│   ├── hiera_classifier              # The Hiera classifier module
│   │   └── manifests
│   │       └── init.pp
│   ├── profile                       # The profile module
│   │   ├── data
│   │   │   ├── Ubuntu.yaml           # Hiera data for Ubuntu OS
│   │   │   └── common.yaml           # Common Hiera data
│   │   ├── functions
│   │   │   └── banner.pp             # Profile::Banner example function
│   │   ├── hiera.yaml                # Module's Hiera config
│   │   ├── manifests
│   │   │   ├── common
│   │   │   │   └── packages.pp       # Profile::Common::Packages example class
│   │   │   ├── common.pp             # Profile::Common example class
│   │   │   └── example.pp            # Profile::Example example class
│   │   └── types
│   │       └── ensure.pp             # Profile::Ensure example type alias
│   └── role                          # The role module
│       └── manifests
│           ├── example.pp            # Role::Example role definition
│           └── unassigned.pp         # Role::Unassigned role definition
└── spec                              # Unit and acceptance tests directory
    ├── acceptance                    # Beaker acceptance tests goes here
    │   ├── example1_spec.rb          # `example1` node beaker-rspec spec
    │   └── nodesets                  # Node definitions for Beaker acceptance tests
    │       └── example1.yml          # `example1` node definition
    ├── classes                       # rspec-puppet class tests goes here
    │   └── profile
    │       ├── common
    │       │   └── packages_spec.rb  # Profile::Common::Package class unit tests
    │       └── example_spec.rb       # Profile::Example class unit tests
    ├── default_facts.yml             # PDK: default facts for unit testing
    ├── functions
    │   └── profile
    │       └── banner_spec.rb        # Profile::Banner function unit test
    ├── defines                       # rspec-puppet defined resource tests goes here
    ├── fixtures                      # rspec-puppet fixtures
    ├── hosts                         # rspec-puppet host tests goes here
    │   └── example1_spec.rb          # `example1` host test
    ├── spec_helper.rb                # PDK: unit test rspec helper
    ├── spec_helper_acceptance.rb     # Acceptance test rspec helper
    ├── spec_helper_local.rb          # unit test rspec helper (local additions)
    └── type_aliases
        └── profile
            └── ensure_spec.rb        # Profile::Ensure type alias unit test
```

### Hiera classifier

... to be written...

### Unit tests

... to be written...

### Acceptance tests

... to be written...
