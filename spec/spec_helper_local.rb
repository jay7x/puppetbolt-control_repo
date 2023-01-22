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

RSpec.configure do |c|
  c.module_path = module_path.join(':')
  c.setup_fixtures = false
  c.manifest_dir = File.join(project_dir, 'manifests')
  c.manifest = File.join(c.manifest_dir, 'site.pp')
  c.hiera_config = File.join(project_dir, 'hiera.yaml')
end

RSpec.shared_context 'clean room' do
  let(:node) { 'this.is.only.used.for.unit.tests' }
  let(:hiera_config) { '/dev/null' }
end
