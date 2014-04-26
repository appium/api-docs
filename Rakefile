require 'middleman-gh-pages'
require_relative 'lib/api_docs'

task :default => [:build]

desc 'Merge markdown files'
task :md, :target_folder do |task, args|
  target_folder = args[:target_folder]
  exit_with 'Must pass target_folder' unless target_folder
  output = File.expand_path(File.join(__dir__, 'source'))
  markdown glob: target_folder, output: output
end