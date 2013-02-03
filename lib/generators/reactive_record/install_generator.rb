require "reactive_record"

module ReactiveRecord
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ReactiveRecord

      desc "Adds models based upon your existing Postgres DB"
      argument :database_name, :type => :string

      def create_models
        db = PG.connect dbname: database_name
        table_names(db).each do |table|
          create_file "app/models/#{table.underscore.pluralize}.rb", model_definition(db, table)
        end
      end
    end
  end
end

