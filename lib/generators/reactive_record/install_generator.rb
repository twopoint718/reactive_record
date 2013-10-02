require "reactive_record"

module ReactiveRecord
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ReactiveRecord

      desc "Adds models based upon your existing Postgres DB"

      def create_models
        db_env = Rails.configuration.database_configuration[Rails.env]
        raise 'You must use the pg database adapter' unless db_env['adapter'] == 'postgresql'
        db = PG.connect dbname: db_env['database']
        table_names(db).each do |table|
          unless table == 'schema_migrations'
            create_file "app/models/#{table.underscore.pluralize}.rb", model_definition(db, table)
          end
        end
      end
    end
  end
end

