require 'rspec'
require_relative '../lib/lexer.rb'
require_relative '../lib/parser.rb'
require_relative '../lib/code_generator.rb'

describe ConstraintParser::Parser do
  let(:lex){ConstraintParser::Lexer}
  let(:par){ConstraintParser::Parser}

  it 'parses an empty check' do
    @parser = par.new(lex.new StringIO.new 'CHECK ()')
    @parser.parse.should == [:check, nil]
  end

  it 'parses a simple expression' do
    @parser = par.new(lex.new StringIO.new "CHECK (((email)::text ~~ '%@bendyworks.com'::text))")
    @parser.parse.should == [:check,
                              [:match,
                                [:type, :text, [:ident, 'email']],
                                [:type, :text, '%@bendyworks.com']]]
  end

  it "UNIQUE (email)" do
    @parser = par.new(lex.new StringIO.new 'UNIQUE (email)')
    @parser.parse.should == [:unique,
                              [:ident, 'email']]
  end

  it "CHECK ((start_date <= ('now'::text)::date))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= ('now'::text)::date))")
    @parser.parse.should == [:check,
                              [:lteq,
                                [:ident, 'start_date'],
                                [:type, :date, [:type, :text, 'now']]]]
  end

  it "CHECK ((start_date <= (('now'::text)::date + 365)))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= (('now'::text)::date + 365)))")
    @parser.parse.should == [:check,
                              [:lteq,
                                [:ident, 'start_date'],
                                [:plus,
                                  [:type, :date, [:type, :text, 'now']],
                                  365]]]
  end

  it "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT" do
    @parser = par.new(lex.new StringIO.new "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT")
    @parser.parse.should be_true
  end
end
