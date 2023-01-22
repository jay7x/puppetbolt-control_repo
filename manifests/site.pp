# See site-modules/hiera_classifier
node default {
  include hiera_classifier
}

# Node name to use in unit test only
node 'this.is.only.used.for.unit.tests' {}
