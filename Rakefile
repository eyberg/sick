task :build do
  system "gem build sick.gemspec"
end

desc "Run specs"
task :spec do
  system "rspec -fs --color spec/spec_helper.rb"
end

# DO NOT RUN ME
task :release => :build do
  system "gem push sick-#{Sick::VERSION}.gem"
end

=begin
require 'rubygems'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('*_spec.rb')
  #t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--color --format progress'
  t.rcov = true
end
=end
