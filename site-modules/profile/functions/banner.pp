# @summary Returns "Managed by Puppet"-style banner text to use in templates
#
# @example Calling the function from a EPP template:
#   # <%= profile::banner() %>
#
# @return [String] "Managed by Puppet"-style banner text
function profile::banner() {
  return 'THIS FILE IS MANAGED BY PUPPET - DO NOT EDIT!'
}
