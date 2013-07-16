# Chef Serverspec Handler

## ABOUT

Chef handler to convert all the recipe resources into serverspec examples.

## INSTALL

    gem install chef-serverspec-handler

## USAGE

Edit your solo.rb config file to add this:

    require 'chef-serverspec-handler'
    
    report_handlers << ChefServerspecHandler.new('/path/to/your/target/dir')

Then run chef (--whyrun option will be useful to just generate examples not affecting any parts of your system):

    chef-solo -c solo.rb -j dna.json --whyrun

As you see, `chef-serverspec-handler` will be called at the end of the chef run, and generates serverspec examples to
`/path/to/your/target/dir`.

And, you can run tests like this:

    serverspec /path/to/your/target/

## SEE ALSO

 * serverspec
 * chef-handler

## LICENSE

