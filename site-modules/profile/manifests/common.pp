# @summary The common profile should include modules to manage everywhere
class profile::common {
  include profile::common::packages
}
