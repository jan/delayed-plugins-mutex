# Delayed::Plugins::Mutex

`delayed_job` plugin for mutual exclusion.

Define, how many jobs of a certain kind can be enqueued or run at the same time.

## Installation

Add this line to your application's Gemfile:

    gem 'delayed-plugins-mutex', git: 'https://github.com/jan/delayed-plugins-mutex'

Import and run migration:

    TODO How to import migration
    
    bundle exec rake db:migrate

Register the plugin like so:

    require 'delayed-plugins-mutex'
    Delayed::Worker.plugins << Delayed::Plugins::Mutex::Plugin
    Delayed::Plugins::Mutex::Plugin.new # Not sure, why this is needed

In a Rails project, this can be done in `config/initializers`.

## Usage

When calling delay, you can now optionally pass new arguments:

   # If another job with the same identifier is already enqueued, this does nothing:
   Foo.delay(enqueue_mutex: 'some identifier')
   
   # If two other jobs with the same identifier are already enqueued, this does nothing:
   Foo.delay(enqueue_mutex: 'some identifier', enqueue_limit: 2)

   # If another job with the same identifier is already locked, don't perform this:
   Foo.delay(perform_mutex: 'some identifier')
   
   # If two other jobs with the same identifier are already locked, don't perform this:
   Foo.delay(perform_mutex: 'some identifier', perform_limit: 2)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request