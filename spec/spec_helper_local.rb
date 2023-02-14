# frozen_string_literal: true

# Configure module path
project_dir = File.expand_path(File.join(__dir__, '..'))

# Use module path from environment.conf
env_module_paths = []
File.open(File.join(project_dir, 'environment.conf')).each do |line|
  v = line.match %r{^modulepath\s*=\s*(.*)$}
  next unless v

  env_module_paths = v[1].split(':').reject { |x| x[0] == '$' } # skip $variables
  break
end

module_path = [
  # File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'modules')),
] + env_module_paths

# Shared context to enable hiera if required
RSpec.shared_context 'with_hiera' do
  let(:hiera_config) { File.join(project_dir, 'hiera.yaml') }
end

# "clean room" shared context
RSpec.shared_context 'clean_room' do
  let(:node) { 'this.is.only.used.for.unit.tests' }
  let(:hiera_config) { '/dev/null' }
end

RSpec.configure do |c|
  c.module_path = module_path.join(':')
  c.setup_fixtures = false
  c.manifest_dir = File.join(project_dir, 'manifests')
  c.manifest = File.join(c.manifest_dir, 'site.pp')
  c.hiera_config = '/dev/null' # No hiera for unit tests by default

  # To remove on RSpec >= 4
  # https://relishapp.com/rspec/rspec-core/v/3-12/docs/example-groups/shared-context
  c.shared_context_metadata_behavior = :apply_to_host_groups

  # Run non-host tests in a clean room (fake node, no hiera)
  c.include_context 'clean_room', file_path: proc { |x| !File.dirname(x).end_with? 'hosts' }
  # Run host tests with hiera enabled
  c.include_context 'with_hiera', file_path: proc { |x| File.dirname(x).end_with? 'hosts' }
end
