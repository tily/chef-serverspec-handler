# Chef Serverspec Handler

## ABOUT

Chef handler to convert recipe resources into serverspec examples.

## INSTALL

    gem install chef-serverspec-handler

## USAGE

Edit your solo.rb config file to add lines like this:

    require 'chef-serverspec-handler'
    
    report_handlers << ChefServerspecHandler.new(:output_dir => '/path/to/dir')

Then run chef with --whyrun option (for not affecting your working system):

    chef-solo -c solo.rb -j dna.json --whyrun

`chef-serverspec-handler` will be called at the end of the chef run, and generates serverspec examples to
`/path/to/dir`.

For example, if you have recipe like this,

`chef-serverspec-handler` generates the test like this.

For more example, see `generated-spec/cookbooks/chef_serverspec_handler_test/recipes/default.rb` and `generated-spec/spec/localhost/chef_serverspec_handler_test/default.rb`.

## SUPPORTED RESOURCES


## SEE ALSO

 * serverspec
 * chef-handler
