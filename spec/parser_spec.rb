require 'rspec'
require_relative '../lib/lexer.rb'
require_relative '../lib/parser.rb'
require_relative '../lib/code_generator.rb'

describe ConstraintParser::Parser do
  let(:lex){ConstraintParser::Lexer}
  let(:par){ConstraintParser::Parser}

  it 'CHECK ()' do
    @parser = par.new(lex.new StringIO.new 'CHECK ()')
    @parser.parse.gen.should == 'validate { true }'
  end

  it "CHECK (((email)::text ~~ '%@bendyworks.com'::text))" do
    @parser = par.new(lex.new StringIO.new "CHECK (((email)::text ~~ '%@bendyworks.com'::text))")
    @parser.parse.gen.should  == 'validate { errors.add(:email, "Expected TODO") unless email =~ /.*@bendyworks.com/ }'
  end

  it "UNIQUE (email)" do
    @parser = par.new(lex.new StringIO.new 'UNIQUE (email)')
    @parser.parse.gen.should == "validates :email, uniqueness: true"
  end

  it "CHECK ((start_date <= ('now'::text)::date))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= ('now'::text)::date))")
    @parser.parse.gen.should == "validate { errors.add(:start_date, \"Expected TODO\") unless start_date <= Time.now.to_date }"
  end

  it "CHECK ((start_date <= (('now'::text)::date + 365)))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= (('now'::text)::date + 365)))")
    @parser.parse.gen.should == 'validate { errors.add(:start_date, "Expected TODO") unless start_date <= Time.now.to_date + 365 }'
  end

  it "CHECK (((port >= 1024) AND (port <= 65634)))" do
    @parser = par.new(lex.new StringIO.new "CHECK (((port >= 1024) AND (port <= 65634)))")
    @parser.parse.gen.should == 'validate { errors.add(:port, "Expected TODO") unless port >= 1024 && port <= 65634 }'
  end

  it "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT" do
    @parser = par.new(lex.new StringIO.new "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT")
    @parser.parse.gen.should == "belongs_to :employees, foreign_key: 'employee_id', class: 'Employees', primary_key: 'employee_id'"
  end
end
