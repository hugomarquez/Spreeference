# spreeference

[![Gem Version](https://badge.fury.io/rb/spreeference.svg)](https://badge.fury.io/rb/spreeference)
[![Build Status](https://travis-ci.org/hugomarquez/spreeference.svg?branch=master)](https://travis-ci.org/hugomarquez/spreeference)
[![Coverage Status](https://coveralls.io/repos/github/hugomarquez/spreeference/badge.svg?branch=master)](https://coveralls.io/github/hugomarquez/spreeference?branch=master)

## Overview
The reason for this gem is to extract from Spree Core the Preferences functionality, which can be used in other projects besides Spree and e-commerce.

Copyright (c) 2009-2015 [Spree Commerce][1] and [Contributors][2], released under the [New BSD License][3]

[1]: https://github.com/spree
[2]: https://github.com/hugomarquez/spreeference/graphs/contributors
[3]: https://github.com/hugomarquez/spreeference/blob/master/LICENSE.md

Spreeference preferences support general application configuration and preferences per model instance. Additional preferences can be added by your application or included extensions.

To implement preferences for a model, simply add a new column called `preferences`. This is an example migration:

```ruby
class AddPreferencesColumnToProducts < ActiveRecord::Migration[4.2]
  def up
    add_column :products, :preferences, :text
  end

  def down
    remove_column :products, :preferences
  end
end
```
This will work if your model is a subclass of `Spreeference::ApplicationRecord`. If found, the `preferences`attribute gets serialized into a `Hash` and merged with the default values.

As another example, you might want to add preferences for users to manage their notification settings. Just make sure your `User` model inherits from `Spreeference::ApplicationRecord` then add the `preferences` column. You'll then be able to define preferences for `User`s without adding extra columns to the database table.

## Installing into a new Rails application
To get up and running with spreeference in a new Rails application is simple. Just follow the instructions below.
		
		rails new my_project
		cd my_project
		echo "gem 'spreeference'" >> Gemfile
		bundle
		rails g spreeference:install
		rake db:migrate

### Motivation

Preferences for models within an application are very common. Although the rule of thumb is to keep the number of preferences available to a minimum, sometimes it's necessary if you want users to have optional preferences like disabling e-mail notifications.

Both use cases are handled by Spreeferences. They are easy to define, provide quick cached reads, persist across restarts and do not require additional columns to be added to your models' tables.

## General Settings

Spreeference comes with many application-wide preferences. They are defined in `app/models/spreeference/app_configuration.rb` and made available to your code through `Spreeference::Config`, e.g., `Spreeference::Config.site_name`.

You can add additional preferences under the `spreeference/app_configuration` namespace or create your own subclass of `Spreeference::Configuration`.

```ruby
# These will be saved with key: spreeference/app_configuration/hot_salsa
Spreeference::AppConfiguration.class_eval do
  preference :hot_salsa, :boolean
  preference :dark_chocolate, :boolean, default: true
  preference :color, :string
  preference :favorite_number
  preference :language, :string, default: 'English'
end

# Spreeference::Config is an instance of Spreeference::AppConfiguration
Spreeference::Config.hot_salsa = false

# Create your own class
# These will be saved with key: kona/store_configuration/hot_coffee
Kona::StoreConfiguration < Spreeference::Configuration
  preference :hot_coffee, :boolean
  preference :color, :string, default: 'black'
end

KONA::STORE_CONFIG = Kona::StoreConfiguration.new
puts KONA::STORE_CONFIG.hot_coffee
```

## Defining Preferences

You can define preferences for a model within the model itself:

```ruby
class User < Spreeference::ApplicationRecord
  preference :hot_salsa, :boolean
  preference :dark_chocolate, :boolean, default: true
  preference :color, :string
  preference :favorite_number, :integer
  preference :language, :string, default: "English"
end
```
In the above model, five preferences have been defined:

* `hot_salsa`
* `dark_chocolate`
* `color`
* `favorite_number`
* `language`

For each preference, a data type is provided. The types available are:

* `boolean`
* `string`
* `password`
* `integer`
* `text`
* `array`
* `hash`

An optional default value may be defined which will be used unless a value has been set for that specific instance.

## Accessing Preferences

Once preferences have been defined for a model, they can be accessed either using the shortcut methods that are generated for each preference or the generic methods that are not specific to a particular preference.

### Shortcut Methods

There are several shortcut methods that are generated. They are shown below.

Query methods:

```ruby
user.prefers_hot_salsa? # => false
user.prefers_dark_chocolate? # => false
```

Reader methods:

```ruby
user.preferred_color      # => nil
user.preferred_language   # => "English"
```

Writer methods:

```ruby
user.prefers_hot_salsa = false         # => false
user.preferred_language = "English"    # => "English"
```

Check if a preference is available:

```ruby
user.has_preference? :hot_salsa
```

### Generic Methods

Each shortcut method is essentially a wrapper for the various generic methods shown below:

Query method:

```ruby
user.prefers?(:hot_salsa)       # => false
user.prefers?(:dark_chocolate)  # => false
```

Reader methods:

```ruby
user.preferred(:color)      # => nil
user.preferred(:language)   # => "English"
```

```ruby
user.get_preference :color
user.get_preference :language
```

Writer method:

```ruby
user.set_preference(:hot_salsa, false)     # => false
user.set_preference(:language, "English")  # => "English"
```
### Accessing All Preferences

You can get a hash of all stored preferences by accessing the `preferences` helper:

```ruby
user.preferences # => {"language"=>"English", "color"=>nil}
```

This hash will contain the value for every preference that has been defined for the model instance, whether the value is the default or one that has been previously stored.

### Default and Type

You can access the default value for a preference:

```ruby
user.preferred_color_default # => 'blue'
```

Types are used to generate forms or display the preference. You can also get the type defined for a preference:

```ruby
user.preferred_color_type # => :string
```
### Configuration Through an Initializer

During the Spreeference installation process, an initializer file is created within your application's source code. The initializer is found under `config/initializers/spreeference.rb`:

```ruby
Spreeference.config do |config|
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Spree Demo Site"
end
```
The `Spreeference.config` block acts as a shortcut to setting `Spreeference::Config` multiple times. If you have multiple default preferences you would like to override within your code you may override them here. Using the initializer for setting the defaults is a nice shortcut, and helps keep your preferences organized in a standard location.

## Site-Wide Preferences

You can define preferences that are site-wide and don't apply to a specific instance of a model by creating a configuration file that inherits from `Spreeference::Configuration`.

```ruby
class MyApplicationConfiguration < Spreeference::Configuration
  preference :theme, :string, default: "Default"
  preference :show_splash_page, :boolean
  preference :number_of_articles, :integer
end
```

In the above configuration file, three preferences have been defined:

* theme
* show_splash_page
* number_of_articles

### Configuring Site-Wide Preferences

The recommended way to configure site-wide preferences is through an initializer. Let's take a look at configuring the preferences defined in the previous configuration example.

```ruby
module Spree
  MyApp::Config = MyApplicationConfiguration.new
end

MyApp::Config[:theme] = "blue_theme"
MyApp::Config[:show_spash_page] = true
MyApp::Config[:number_of_articles] = 5
```

The `MyApp` name used here is an example and should be replaced with your actual application's name, found in `config/application.rb`.

The above example will configure the preferences we defined earlier. Take note of the second line. In order to set and get preferences using `MyApp::Config`, we must first instantiate the configuration object.

