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
            validate { errors.add(:email, "Expected TODO") unless email =~ /.*@example.com/ }
            validate { errors.add(:start_date, "Expected TODO") unless start_date >= Date.parse(\"2009-04-13\") }
            validate { errors.add(:start_date, "Expected TODO") unless start_date <= Time.now.to_date + 365 }
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

  context '#constraints' do
    it 'gathers all constraints on the employees table' do
      constraints(@db, 'employees').to_a.should == [
        {"table_name"=>"employees", "constraint_name"=>"company_email", "constraint_src"=>"CHECK (((email)::text ~~ '%@example.com'::text))"},
        {"table_name"=>"employees", "constraint_name"=>"employees_email_key", "constraint_src"=>"UNIQUE (email)"},
        {"table_name"=>"employees", "constraint_name"=>"employees_pkey", "constraint_src"=>"PRIMARY KEY (id)"},
        {"table_name"=>"employees", "constraint_name"=>"founding_date", "constraint_src"=>"CHECK ((start_date >= '2009-04-13'::date))"},
        {"table_name"=>"employees", "constraint_name"=>"future_start_date", "constraint_src"=>"CHECK ((start_date <= (('now'::text)::date + 365)))"}
      ]
    end
    it 'gathers all constraints on the projects table' do
      constraints(@db, 'projects').to_a.should == [
        {"table_name"=>"projects", "constraint_name"=>"projects_name_key", "constraint_src"=>"UNIQUE (name)"},
        {"table_name"=>"projects", "constraint_name"=>"projects_pkey", "constraint_src"=>"PRIMARY KEY (id)"}
      ]
    end
    it 'gathers all constraints on the employees_projects table' do
      constraints(@db, 'employees_projects').to_a.should == [
        {
          "table_name"=>"employees_projects",
          "constraint_name"=>"employees_projects_employee_id_fkey",
          "constraint_src"=>"FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT"
        },
        {
          "table_name"=>"employees_projects",
          "constraint_name"=>"employees_projects_pkey",
          "constraint_src"=>"PRIMARY KEY (employee_id, project_id)"
        },
        {
          "table_name"=>"employees_projects",
          "constraint_name"=>"employees_projects_project_id_fkey",
          "constraint_src"=>"FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE"
        }
      ]
    end
  end

  context '#generate_constraints' do
    it 'generates ruby code for employees constraints' do
      generate_constraints(@db, 'employees').should == [
        "validate { errors.add(:email, \"Expected TODO\") unless email =~ /.*@example.com/ }",
        "validate { errors.add(:start_date, \"Expected TODO\") unless start_date >= Date.parse(\"2009-04-13\") }",
        "validate { errors.add(:start_date, \"Expected TODO\") unless start_date <= Time.now.to_date + 365 }",
      ]
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
