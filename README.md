# ActiveRecord-Userstamp [![Build Status](https://travis-ci.org/lowjoel/activerecord-userstamp.svg)](https://travis-ci.org/lowjoel/activerecord-userstamp) [![Coverage Status](https://coveralls.io/repos/lowjoel/activerecord-userstamp/badge.svg?branch=master&service=github)](https://coveralls.io/github/lowjoel/activerecord-userstamp?branch=master) [![Code Climate](https://codeclimate.com/github/lowjoel/activerecord-userstamp/badges/gpa.svg)](https://codeclimate.com/github/lowjoel/activerecord-userstamp)

## Overview

Userstamp extends `ActiveRecord::Base` to add automatic updating of `creator`, `updater`, and 
`deleter` attributes. It is based loosely on `ActiveRecord::Timestamp`.

Two class methods (`model_stamper` and `stampable`) are implemented in this gem. The `model_stamper`
method is used in models that are responsible for creating, updating, or deleting other objects.
Typically this would be the `User` model of your application. The `stampable` method is used in 
models that are subject to being created, updated, or deleted by stampers.

## Forkception

This is a fork of:

 - the [magiclabs-userstamp](https://github.com/magiclabs/userstamp) gem
 - which is a fork of [Michael Grosser's](https://github.com/grosser)
   [userstamp gem] (https://github.com/grosser/userstamp) 
 - which is a fork of the original [userstamp plugin](https://github.com/delynn/userstamp) by
   [delynn](https://github.com/delynn)

In addition to these, I have cherry picked ideas and changes from the following forks:

 - [simplificator](https://github.com/simplificator/userstamp)
 - [akm](https://github.com/akm/magic_userstamp)
 - [konvenit](https://github.com/konvenit/userstamp)

Finally, this gem only supports Ruby 2.0 and above. Yes, you really should upgrade to a supported
version of Ruby.

## Features
### Soft-deletes
The reason for this is because the original userstamp plugin does not support databases utilising
soft deletes. They are not tested explicitly within this gem, but it is expected to work with the
following gems:

 - [acts_as_paranoid](https://github.com/ActsAsParanoid/acts_as_paranoid)
 - [paranoia](https://github.com/radar/paranoia)

The `stampable` method has been modified to allow additional arguments to be passed to the 
creator/updater relations. This allows declarations like:

```ruby
  stampable with_deleted: true
```

to result in a `belongs_to` relation which looks like:

```ruby
  belongs_to :creator, class_name: '::User', foreign_key: :created_by, with_deleted: true
```

Do create a ticket if it is broken, with a pull-request if possible.  

### Customisable column names/types
While examining the userstamp gem's network on Github, it was noticed that quite a few forks were
made to allow customisability in the name and type of the column with the database migration.

This gem now supports customised column names.

### Saving before validation
This fork includes changes to perform model stamping before validation. This allows models to
enforce the presence of stamp attributes:

```ruby
  validates :created_by, :presence => true
  validates :updated_by, :presence => true
```

Furthermore, the `creator` attribute is set only if the value is blank allowing for a manual
override.

## Usage
Assume that we are building a blog application, with User and Post objects. Add the following 
to the application's Gemfile:

```ruby
  gem 'activerecord-userstamp'
```

Ensure that each model has a set of columns for creators, updaters, and deleters (if applicable.)

```ruby
  class CreateUsers < ActiveRecord::Migration
    def self.up
      create_table :users, :force => true do |t|
        ...
        t.userstamps # use t.userstamps(true) if you also want 'deleter_id'
      end
    end

    def self.down
      drop_table :users
    end
  end

  class CreatePosts < ActiveRecord::Migration
    def self.up
      create_table :posts, :force => true do |t|
        ...
        t.userstamps # use t.userstamps(true) if you also want 'deleter_id'
      end
    end

    def self.down
      drop_table :posts
    end
  end
```

Declare the stamper on the User model:

```ruby
  class User < ActiveRecord::Base
    model_stamper
  end
```

And declare that the Posts are stampable:

```ruby
  class Post < ActiveRecord::Base
    stampable
  end
```

If your stamper is called `User`, that's it; you're done.

## Customisation
More than likely you want all your associations setup on your stamped objects, and that's where the
`stampable` class method comes in. So in our example we'll want to use this method in both our 
User and Post classes:

```ruby
  class User < ActiveRecord::Base
    model_stamper
    stampable
  end

  class Post < ActiveRecord::Base
    stampable
  end
```

Okay, so what all have we done? The `model_stamper` class method injects two methods into the
`User` class. They are `#stamper=` and `#stamper` and look like this:

  def stamper=(object)
    object_stamper = if object.is_a?(ActiveRecord::Base)
      object.send("#{object.class.primary_key}".to_sym)
    else
      object
    end

    Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = object_stamper
  end

  def stamper
    Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"]
  end

The `stampable` method allows you to customize what columns will get stamped, and also creates the
`creator`, `updater`, and `deleter` associations.

The Userstamp module that we included into our ApplicationController uses the setter method to
set which user is currently making the request. By default the 'set_stampers' method works perfectly
with the RestfulAuthentication[http://svn.techno-weenie.net/projects/plugins/restful_authentication] plug-in:

  def set_stampers
    User.stamper = self.current_user
  end

If you aren't using ActsAsAuthenticated, then you need to create your own version of the
<tt>set_stampers</tt> method in the controller where you've included the Userstamp module.

Now, let's get back to the Stampable module (since it really is the interesting one). The Stampable
module sets up before_* filters that are responsible for setting those attributes at the appropriate
times. It also creates the belongs_to relationships for you.

If you need to customize the columns that are stamped, the <tt>stampable</tt> method can be
completely customized. Here's an quick example:

  class Post < ActiveRecord::Base
    stampable :stamper_class_name => :person,
              :creator_attribute  => :create_user,
              :updater_attribute  => :update_user,
              :deleter_attribute  => :delete_user,
              :deleter => true,
              :with_deleted => true
  end

## Upgrading
### Upgrading from delynn's 1.x/2.x with `compatibility_mode`
The major difference between 1.x and 2.x is the naming of the columns. This version of the gem 
allows specifying the name of the column from the gem configuration:

```ruby
ActiveRecord::Userstamp.configure do |config|
  config.creator_attribute = :created_by
  config.updater_attribute = :updated_by
  config.deleter_attribute = :deleted_by
end
```

Furthermore, there is no need to include the `Userstamp` module in `ApplicationController`.

However, this is where the bulk of the work is: since this is a fork of insphire's gem, where he 
has removed making every `ActiveRecord::Base` subclass automatically a 

### Upgrading from magiclabs-userstamp

There is no need to include the `Userstamp` module in `ApplicationController`.

## Tests
Run

    $ bundle exec rspec

## Authors
 - [DeLynn Berry](http://delynnberry.com/): The original idea for this plugin came from the Rails
   Wiki article entitled
   [Extending ActiveRecord](http://wiki.rubyonrails.com/rails/pages/ExtendingActiveRecordExample)
 - [Michael Grosser](http://pragmatig.com)
 - [John Dell](http://blog.spovich.com/)
 - [Chris Hilton](https://github.com/chrismhilton)
 - [Thomas von Deyen](https://github.com/tvdeyen)
 - [Joel Low](http://joelsplace.sg)
