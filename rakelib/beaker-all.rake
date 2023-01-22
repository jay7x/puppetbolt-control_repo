namespace :beaker do
  desc 'Run all acceptance tests'
  task :all do
    project_dir = File.expand_path(__dir__)
    nodesets = Dir.glob(File.join(project_dir, 'spec', 'acceptance', 'nodesets', '*.yml'))
    puts "Nodesets: #{nodesets.map { |x| File.basename(x) }}"
    ENV['BEAKER_debug'] = 'no'
    nodesets.each do |nodeset|
      ENV['BEAKER_setfile'] = nodeset
      Rake::Task[:beaker].invoke
    end
  end
end

