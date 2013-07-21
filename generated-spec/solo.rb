$:.unshift File.dirname(__FILE__) + '/../lib/'
require 'chef-serverspec-handler'

here = File.absolute_path File.dirname(__FILE__)

file_cache_path here
cookbook_path File.join(here, 'cookbooks')

log_level :info

report_handlers << ChefServerspecHandler.new(
  :output_dir => File.join(here, 'spec/localhost'),
  :force => true
)
