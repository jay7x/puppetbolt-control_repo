# @summary This role is selected when no specific role is set for a node
class role::unassigned {
  fail('No role is assigned to the node!')
}
