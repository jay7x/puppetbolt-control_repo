require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: nil)

# Deploy the current directory as the 'production' environment to every host
copy_module_to(hosts, module_name: 'production', target_module_path: '/etc/puppetlabs/code/environments')
