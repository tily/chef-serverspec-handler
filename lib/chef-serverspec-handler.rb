require 'erb'
require 'fileutils'

class ServerspecGenerator < Chef::Handler

  SUPPORTED_RESOURCES = {
    Chef::Resource::File => [:create],
    Chef::Resource::CookbookFile => [:create],
    Chef::Resource::Template => [:create],
    Chef::Resource::Package => [:create],
    Chef::Resource::Package => [:enable, :start]
  }

  def initialize(dir)
    @dir = dir
    @resources_by_recipe = Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = []}}
  end

  def report
    all_resources.each do |resource|
      if SUPPORTED_RESOURCES.keys.include?(resource.class)
        actions = [resource.action].flatten.map {|a| a.to_sym }
        p "#{actions}, #{SUPPORTED_RESOURCES[resource.class]}" 
        if (SUPPORTED_RESOURCES[resource.class] & actions).size > 0
          @resources_by_recipe[resource.cookbook_name][resource.recipe_name] << resource
        end
      end
    end

    @resources_by_recipe.each do |cookbook, recipes|
      FileUtils.mkdir_p File.join(@dir, "spec/#{cookbook}")

      recipes.each do |recipe, resources|
        template = File.read('/root/template.erb')
        spec = ERB.new(template, nil, '-').result(binding)
        File.open File.join(@dir, "spec/#{cookbook}/#{recipe}_spec.rb"), 'w' do |f|
          f.write(spec)
        end
      end
    end
  end
end

