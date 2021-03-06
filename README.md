# Kadmin

[![GitHub release](https://img.shields.io/badge/release-0.6.6-blue.png)](https://github.com/barcoo/kadmin/releases/tag/0.6.6)

Collection of utility, configuration, etc., for admin areas in different projects.
Theme based on [Modular Admin](https://github.com/modularcode/modular-admin-html)

## Installation

Add to your gemfile:

```ruby
gem 'kadmin', git: 'git@github.com:barcoo/kadmin.git'
```

## Development

### Use local gem 
In case you want to test changes locally before commiting to the repository you can setup your environment to use the local version instead:
```bash
bundle config local.kadmin $YOUR_LOCAL_KADMIN_PATH/
```
change Gemfile to:
```ruby
gem 'kadmin', git: 'https://github.com/barcoo/kadmin', branch: "master" # change branch to your working branch name
```
```bash
bundle install
```
you should see something similiar to: 
'Using kadmin 1.0.8 from https://github.com/barcoo/kadmin (at $YOUR_LOCAL_KADMIN_PATH@9203125)'

When you're finished remove the local setup by changing your Gemfile back and execute
```bash
bundle config --delete local.kadmin
```

Source: [How to specify local Ruby gems in your Gemfile](https://rossta.net/blog/how-to-specify-local-ruby-gems-in-your-gemfile.html)

### kadmin internals...
Clone, bundle install, run migrations.

Third-party libraries that are manually added should go in vendor/, including assets (e.g. `vendor/assets/stylesheets/modular`).

Reusable, non page specific components should go into app/components (e.g. Kadmin::Finder, Kadmin::Pager, etc.).

Avoid using helpers, instead create models with presenters (i.e. view models). See `lib/presenter.rb` and `lib/presentable.rb`. For an example of a presentable object, see `app/components/pager.rb` and `app/components/pager/presenter.rb`.

Make sure to read the following:

 - http://guides.rubyonrails.org/active_support_core_extensions.html (be aware of provided ActiveSupport extensions)
 - http://guides.rubyonrails.org/routing.html (be aware of how routing works in and outside of an engine)
 - http://guides.rubyonrails.org/asset_pipeline.html (know how the asset pipeline packages things together; if in doubt, run `bundle exec rake app:assets:precompile` and see the output in `test/dummy/public/assets`)
 - http://guides.rubyonrails.org/autoloading_and_reloading_constants.html (understand how constants are autoloaded/reloaded)

If working on the Form objects, do read:
 - http://guides.rubyonrails.org/active_model_basics.html

This covers the basics of ActiveModel, on which the Form object is based.

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
