# reactive_record

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
