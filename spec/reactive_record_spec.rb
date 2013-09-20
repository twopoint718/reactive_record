require 'rspec'
require_relative '../lib/reactive_record'

include ReactiveRecord

describe 'ReactiveRecord' do
  before :all do
    # db setup
    @dbname = "reactive_record_test_#{Process.pid}"

    # N.B. all reactive_record methods are read only and so I believe
    # that it is valid to share a db connection. Nothing reactive record
    # does should mutate any global state
    system "createdb #{@dbname}"
    @db = PG.connect dbname: @dbname
    @db.exec File.read('spec/seed/database.sql')
  end

  after :all do
    # db teardown
    @db.close
    system "pg_dump --schema-only #{@dbname} > schema_dump.sql"
    system "dropdb #{@dbname}"
  end

  context '#model_definition' do
    it 'generates an employee model def' do
      model_definition(@db, 'employees').should ==
        <<-EOS.gsub(/^ {10}/, '')
          class Employees < ActiveRecord::Base
            set_table_name 'employees'
            set_primary_key :id

            validate :id, :name, :email, :start_date, presence: true
            validate :email, uniqueness: true
          end
        EOS
    end

    it 'generates a project model def' do
      model_definition(@db, 'projects').should ==
        <<-EOS.gsub(/^ {10}/, '')
          class Projects < ActiveRecord::Base
            set_table_name 'projects'
            set_primary_key :id

            validate :id, :name, presence: true
            validate :name, uniqueness: true
          end
        EOS
    end
  end

  context '#unique_columns' do
    it 'returns email for employees' do
      unique_columns(@db, 'employees').should == ['email']
    end
  end

  context '#cols_with_contype' do
    it 'identifies UNIQUE columns in database' do
      cols_with_contype(@db, 'employees', 'u').to_a.should == [{"column_name"=>"email", "conname"=>"employees_email_key"},
                                                               {"column_name"=>"name", "conname"=>"projects_name_key"}]
    end
  end

  context '#non_nullable_columns' do
    it 'identifies NOT NULL columns in employees' do
      non_nullable_columns(@db, 'employees').should == ['id', 'name', 'email', 'start_date']
    end
  end
end
