# @summary classifier
#
# @param pp_role
#   Role to assign to the node
class hiera_classifier (
  String[1] $pp_role = 'unassigned',
) {
  include "role::${pp_role}"
}
