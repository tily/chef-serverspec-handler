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

For more example, see below:

 * [input chef recipe]()
 * [output serverspec example]()

## SUPPORTED RESOURCES

 resource name    | actions                          
 -----------------|----------------------------------
 file             | create, create_if_missing, touch
 cookbook_file    | create, create_if_missing
 remote_file      | create, create_if_missing
 directory        | create
 remote_directory | create, create_if_missing
 template         | create, create_if_missing
 link             | create
 user             | create
 group            | create
 service          | start, enable
 cron             | create

## TODO

 * mount
 * apt_package
 * dpkg_package
 * yum_package
 * rpm_package

## SEE ALSO

 * [serverspec](http://serverspec.org/)
 * [About Exception and Report Handlers](http://docs.opscode.com/essentials_handlers.html)
