require 'erubis'
require 'fileutils'
require 'chef'

class ChefServerspecHandler < Chef::Handler

  HERE =  File.absolute_path File.dirname(__FILE__) 

  # TODO: route, ifconfig, scm, git, subversion, chef_gem, gem_package, easy_install_package
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
    Chef::Resource::Cron            => [:create]
  }

  def initialize(options={})
    @options = options

    if @options[:output_dir].nil?
      raise ArgumentError, 'option :output_dir is required'
    end

    if !FileTest.directory?(@options[:output_dir])
      raise ArgumentError, ":ouput_dir is not directory"
    end

    @options[:force] ||= false
  end

  def report
    resources = extract_target_resources

    resources.each do |cookbook, recipes|
      cookbook_dir = File.join(@options[:output_dir], cookbook.to_s)
      FileUtils.mkdir_p cookbook_dir

      recipes.each do |recipe, resources|
        spec_path = File.join(cookbook_dir, "#{recipe}_spec.rb")

        if File.exists?(spec_path) && !@options[:force]
          Chef::Log.warn "ChefServerspecHandler: #{cookbook}/#{recipe}.rb already exists. set :force option to true if you want to override it"
          next
        end

        Chef::Log.info "generating #{cookbook}/#{recipe}_spec.rb"

        File.open(spec_path, 'w') do |file|
          template = File.read File.join(HERE, 'chef-serverspec-handler.erb')
          spec = ERB.new(template, nil, '-').result(binding)
          file.write(spec)
        end
      end
    end
  end

  def extract_target_resources
    resources = Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = []}}

    all_resources.each do |resource|
      if SUPPORTED_RESOURCES.keys.include?(resource.class)
        if (SUPPORTED_RESOURCES[resource.class] & regular_actions(resource)).size > 0
          resources[resource.cookbook_name][resource.recipe_name] << resource
        end
      end
    end

    resources
  end

  def regular_actions(resource)
    [resource.action].flatten.map {|action| action.to_sym }
  end
end
