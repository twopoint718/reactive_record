require 'rspec'
require_relative '../lib/lexer.rb'

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
 it "CHECK (((port >= 1024) AND (port <= 65634)))" do
    @lex = lex.new StringIO.new "CHECK (((port >= 1024) AND (port <= 65634)))"
    @lex.tokenize.should == [
      [:CHECK, 'CHECK'],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:LPAREN, '('],
      [:IDENT, 'port'],
      [:GTEQ, '>='],
      [:INT, "1024"],
      [:RPAREN, ')'],
      [:AND, 'AND'],
      [:LPAREN, '('],
      [:IDENT, 'port'],
      [:LTEQ, '<='],
      [:INT, "65634"],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
      [:RPAREN, ')'],
    ]
  end

end
