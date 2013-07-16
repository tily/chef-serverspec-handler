require 'erb'
require 'fileutils'
require 'chef'

# TODO: chef log output
class ChefServerspecHandler < Chef::Handler

  SUPPORTED_RESOURCES = {
    Chef::Resource::File            => [:create, :create_if_missing, :touch],
    Chef::Resource::CookbookFile    => [:create, :create_if_missing],
    Chef::Resource::RemoteFile      => [:create, :create_if_missing],
    Chef::Resource::Directory       => [:create],
    Chef::Resource::RemoteDirectory => [:create, :create_if_missing],
    Chef::Resource::Template        => [:create, :create_if_missing],
    Chef::Resource::Package         => [:install],
    Chef::Resource::AptPackage      => [:install],
    Chef::Resource::DpkgPackage     => [:install],
    Chef::Resource::YumPackage      => [:install],
    Chef::Resource::RpmPackage      => [:install],
    Chef::Resource::Mount           => [:mount],
    Chef::Resource::Link            => [:create],
    Chef::Resource::User            => [:create],
    Chef::Resource::Group           => [:create],
    Chef::Resource::Service         => [:start, :enable],
    Chef::Resource::Cron            => [:create],
    Chef::Resource::Route           => [:add]
  }

  def initialize(options={})
    @options = options
    if options[:dir].nil?
      raise ArgumentError, 'option :dir must be specified'
    end
    if !FileTest.directory?(options[:dir])
      raise ArgumentError, "directory #{options[:dir]} does not exist"
    end
    @resources_by_recipe = Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = []}}
  end

  def report
    all_resources.each do |resource|
      if SUPPORTED_RESOURCES.keys.include?(resource.class)
        actions = [resource.action].flatten.map {|a| a.to_sym }
        if (SUPPORTED_RESOURCES[resource.class] & actions).size > 0
          @resources_by_recipe[resource.cookbook_name][resource.recipe_name] << resource
        end
      end
    end

    @resources_by_recipe.each do |cookbook, recipes|
      cookbook_dir = File.join(@dir, cookbook.to_s)
      FileUtils.mkdir_p cookbook_dir

      recipes.each do |recipe, resources|
        spec_path = File.join(cookbook_dir, "#{recipe}_spec.rb")
        Chef::Log.info "generating spec: #{spec_path}"
        template = File.read(File.dirname(__FILE__) + '/chef-serverspec-handler.erb')
        spec = ERB.new(template, nil, '-').result(binding)
        File.open(spec_path, 'w') do |f|
          f.write(spec)
        end
      end
    end
  end
end

