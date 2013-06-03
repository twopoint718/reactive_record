require 'rspec'
require_relative '../lib/lexer.rb'
require_relative '../lib/parser.rb'
require_relative '../lib/code_generator.rb'

describe ConstraintParser::Parser do
  let(:lex){ConstraintParser::Lexer}
  let(:par){ConstraintParser::Parser}

  it 'parses an empty check' do
    @parser = par.new(lex.new StringIO.new 'CHECK ()')
    @parser.parse.gen.should == 'validate { true }'
  end

  it 'parses a simple expression' do
    @parser = par.new(lex.new StringIO.new "CHECK (((email)::text ~~ '%@bendyworks.com'::text))")
    @parser.parse.gen.should == "validate { errors.add(:email, \"Expected email to match '%@bendyworks.com'\") unless email =~ /.*@bendyworks.com/ }"
  end

  it "UNIQUE (email)" do
    @parser = par.new(lex.new StringIO.new 'UNIQUE (email)')
    @parser.parse.gen.should == "validates :email, uniqueness: true"
  end

  it "CHECK ((start_date <= ('now'::text)::date))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= ('now'::text)::date))")
    @parser.parse.gen.should == "validate { errors.add(:start_date, \"Expected start_date to be less than or equal to 'Time.now.to_date'\") unless start_date <= Time.now.to_date }"
  end

  it "CHECK ((start_date <= (('now'::text)::date + 365)))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= (('now'::text)::date + 365)))")
    @parser.parse.gen.should == "validate { errors.add(:start_date, \"Expected start_date to be less than or equal to 'Time.now.to_date plus 365'\") unless start_date <= Time.now.to_date + 365 }"
  end

  it "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT" do
    @parser = par.new(lex.new StringIO.new "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT")
    # FIXME
    @parser.parse.should == 'belongs_to :employee; validates :employee, presence: true'
  end
end
