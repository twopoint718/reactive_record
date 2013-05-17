require 'rspec'
require_relative '../lib/lexer.rb'
require_relative '../lib/parser.rb'

describe ConstraintParser::Lexer do
  let(:lex){ConstraintParser::Lexer}

  it "CHECK (((email)::text ~~ '%@bendyworks.com'::text))" do
    @lex = lex.new \
      StringIO.new "CHECK (((email)::text ~~ '%@bendyworks.com'::text))"
    @lex.tokenize.should == [
      [:CHECK, 'CHECK'],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:IDENT, 'email'],
      [:RPAREN, ')'],
      [:TYPE, '::'],
      [:IDENT, 'text'],
      [:MATCH_OP, '~~'],
      [:STRLIT, "'%@bendyworks.com'"],
      [:TYPE, '::'],
      [:IDENT, 'text'],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
    ]
  end

  it "UNIQUE (email)" do
    @lex = lex.new StringIO.new "UNIQUE (email)"
    @lex.tokenize.should == [
      [:UNIQUE, 'UNIQUE'],
      [:LPAREN, '('],
      [:IDENT, 'email'],
      [:RPAREN, ')']
    ]
  end

  it "PRIMARY KEY (employee_id)" do
    @lex = lex.new StringIO.new "PRIMARY KEY (employee_id)"
    @lex.tokenize.should == [
      [:PRIMARY_KEY, 'PRIMARY KEY'],
      [:LPAREN, '('],
      [:IDENT, 'employee_id'],
      [:RPAREN, ')']
    ]
  end

  it "CHECK ((start_date >= '2009-04-13'::date))" do
    @lex = lex.new StringIO.new "CHECK ((start_date >= '2009-04-13'::date))"
    @lex.tokenize.should == [
      [:CHECK, 'CHECK'],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:IDENT, 'start_date'],
      [:GTEQ, '>='],
      [:STRLIT, "'2009-04-13'"],
      [:TYPE, '::'],
      [:IDENT, 'date'],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
    ]
  end

  it '"CHECK ((start_date <= ((\'now\'::text)::date + 365)))"' do
    @lex = lex.new StringIO.new "CHECK ((start_date <= ((\'now\'::text)::date + 365)))"
    @lex.tokenize.should == [
      [:CHECK, 'CHECK'],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:IDENT, 'start_date'],
      [:LTEQ, '<='],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:STRLIT, "'now'"],
      [:TYPE, '::'],
      [:IDENT, 'text'],
      [:RPAREN, ')'],
      [:TYPE, '::'],
      [:IDENT, 'date'],
      [:PLUS, '+'],
      [:INT, '365'],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
    ]
  end

  it "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT" do
    @lex = lex.new StringIO.new "FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT"
    @lex.tokenize.should == [
      [:FOREIGN_KEY, 'FOREIGN KEY'],
      [:LPAREN, '('],
      [:IDENT, 'employee_id'],
      [:RPAREN, ')'],
      [:REFERENCES, 'REFERENCES'],
      [:IDENT, 'employees'],
      [:LPAREN, '('],
      [:IDENT, 'employee_id'],
      [:RPAREN, ')'],
      [:ON, 'ON'],
      [:DELETE, 'DELETE'],
      [:RESTRICT, 'RESTRICT'],
    ]
  end

  it "PRIMARY KEY (employee_id, project_id)" do
    @lex = lex.new StringIO.new "PRIMARY KEY (employee_id, project_id)"
    @lex.tokenize.should == [
      [:PRIMARY_KEY, 'PRIMARY KEY'],
      [:LPAREN, '('],
      [:IDENT, 'employee_id'],
      [:COMMA, ','],
      [:IDENT, 'project_id'],
      [:RPAREN, ')']
    ]
  end

  it "FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE" do
    @lex = lex.new StringIO.new "FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE"
    @lex.tokenize.should == [
      [:FOREIGN_KEY, 'FOREIGN KEY'],
      [:LPAREN, '('],
      [:IDENT, 'project_id'],
      [:RPAREN, ')'],
      [:REFERENCES, 'REFERENCES'],
      [:IDENT, 'projects'],
      [:LPAREN, '('],
      [:IDENT, 'project_id'],
      [:RPAREN, ')'],
      [:ON, 'ON'],
      [:DELETE, 'DELETE'],
      [:CASCADE, 'CASCADE'],
    ]
  end

  it "PRIMARY KEY (project_id)" do
    @lex = lex.new StringIO.new "PRIMARY KEY (project_id)"
    @lex.tokenize.should == [
      [:PRIMARY_KEY, 'PRIMARY KEY'],
      [:LPAREN, '('],
      [:IDENT, 'project_id'],
      [:RPAREN, ')'],
    ]
  end
end

describe ConstraintParser::Parser do
  let(:lex){ConstraintParser::Lexer}
  let(:par){ConstraintParser::Parser}

  it 'parses an empty check' do
    @parser = par.new(lex.new StringIO.new 'CHECK ()')
    @parser.parse.should be_true
  end

  it 'parses a simple expression' do
    @parser = par.new(lex.new StringIO.new "CHECK (((email)::text ~~ '%@bendyworks.com'::text))")
    @parser.parse.should be_true
  end

  it "UNIQUE (email)" do
    @parser = par.new(lex.new StringIO.new 'UNIQUE (email)')
    @parser.parse.should be_true
  end

  it "CHECK ((start_date <= ('now'::text)::date))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= ('now'::text)::date))")
    @parser.parse.should be_true
  end

  it "CHECK ((start_date <= (('now'::text)::date + 365)))" do
    @parser = par.new(lex.new StringIO.new "CHECK ((start_date <= (('now'::text)::date + 365)))")
    @parser.parse.should be_true
  end
end


