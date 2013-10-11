# reactive_record

![Reactive Record logo](https://raw.github.com/twopoint718/reactive_record/master/doc/reactive_record.png)

Generates ActiveRecord models to fit a pre-existing Postgres database.
Now you can use Rails with the db schema you always wanted. It's
**your** convention over configuration.

## Why?

1. Your app is specific to Postgres and proud of it. You use the mature
   declarative data validation that only a real database can provide.
1. You have inherited a database or are more comfortable creating one
   yourself.
1. You're a grown-ass DBA who doesn't want to speak ORM baby-talk.

## Features

* Fully automatic. It just works.
* Creates a model for every table.
* Creates a comprehensive initial migration.
* Declares key-, uniqueness-, and presence-constraints.
* Creates associations.
* Adds custom validation methods for `CHECK` constraints.

## Usage

### Already familiar with Rails?

* Set up a postgres db normally
* Set `config.active_record.schema_format = :sql` to use a SQL `schema.rb`
* After you have migrated up a table, use `rails generate reactive_record:install`
* Go examine your generated models

### Want more details?

**First** Include the `reactive_record` gem in your project's
`Gemfile`. *Oh by the way*, you'll have to use postgres in your
project. Setting up Rails for use with postgres is a bit outside
the scope of this document. Please see [Configuring a Database]
(http://guides.rubyonrails.org/configuring.html#configuring-a-database)
for what you need to do.

``` ruby
gem 'reactive_record'
```

Bundle to include the library

``` shell
$ bundle
```

**Next** Tell `ActiveRecord` to go into beast-mode. Edit your
`config/application.rb`, adding this line to use sql as the schema
format:

``` ruby
module YourApp
  class Application < Rails::Application
    # other configuration bric-a-brac...
    config.active_record.schema_format = :sql
  end
end
```

**Next** Create the database(s) just like you normally would:

``` shell
rake db:create
```

**Next** Generate a migration that will create the initial table:

``` shell
$ rails generate migration create_employees
```

Use your SQL powers to craft some
[DDL](http://en.wikipedia.org/wiki/Data_definition_language), perhaps
the "Hello, World!" of DB applications, `employees`?

``` ruby
class CreateEmployees < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE employees (
        id         SERIAL,
        name       VARCHAR(255) NOT NULL,
        email      VARCHAR(255) NOT NULL UNIQUE,
        start_date DATE NOT NULL,

        PRIMARY KEY (id),
        CONSTRAINT company_email CHECK (email LIKE '%@example.com')
      );
    SQL
  end

  def down
    drop_table :employees
  end
end
```

**Lastly** Deploy the `reactive_record` generator:

``` shell
$ rails generate reactive_record
```

Go look at the generated file:

``` ruby
class Employees < ActiveRecord::Base
  set_table_name 'employees'
  set_primary_key :id
  validate :id, :name, :email, :start_date, presence: true
  validate :email, uniqueness: true
  validate { errors.add(:email, "Expected TODO") unless email =~ /.*@example.com/ }
end
```

Reactive record does not currently attempt to generate any kind of
reasonable error message (I'm working on it) :)

**Enjoy**
