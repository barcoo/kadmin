# RailsAdmin

[![GitHub release](https://img.shields.io/badge/release-0.1.3-blue.png)](https://github.com/offerista/RailsAdmin/releases/tag/0.1.3)

Collection of utility, configuration, etc., for admin areas in different projects.

## Installation

Add to your gemfile:

```ruby
gem 'rails_admin', git: 'git@github.com:offerista/RailsAdmin.git'
```

## Web

If you wish to use the web front-end, make sure to ```require 'rails_admin'```

See the test application ```test/dummy``` for more info.

## Development

Clone, bundle install

Make sure test coverage stays > 90%, and make sure ```master``` stays green.

## Release

___Note___: eventually use one of the popular git release scripts to tag, create tag notes, etc., based on git changelog.

When you want to create a new release, use the rake task ```cim:release``` (in the main Rakefile)

```shell
bundle exec rake cim:release
```
