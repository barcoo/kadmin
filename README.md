# Kadmin

[![GitHub release](https://img.shields.io/badge/release-0.2.2-blue.png)](https://github.com/barcoo/kadmin/releases/tag/0.2.2)

Collection of utility, configuration, etc., for admin areas in different projects.

## Installation

Add to your gemfile:

```ruby
gem 'kadmin', git: 'git@github.com:barcoo/kadmin.git'
```

## Web

If you wish to use the web front-end, make sure to ```require 'kadmin'```

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

## Roadmap

TODOs:

* [ ] Finish form objects (destruction and creation) + tests + examples
* [ ] Make a generic typehead-select form object
* [x] Wrap Finder objects + view helpers
