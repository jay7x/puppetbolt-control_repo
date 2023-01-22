# Masterless puppet entry point
plan control_repo::apply (
  TargetSpec $targets = 'all',
  Boolean $noop = false,
) {
  apply_prep($targets)
  $apply_results = apply($targets, '_noop' => $noop) {
    include hiera_classifier
  }
}
