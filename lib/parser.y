class ConstraintParser::Parser
prechigh
  left PLUS MATCH_OP
  left GTEQ LTEQ NEQ EQ GT LT
preclow

token CASCADE
      CHECK
      COMMA
      DELETE
      EQ
      FOREIGN_KEY
      GT
      GTEQ
      IDENT
      INT
      LPAREN
      LT
      LTEQ
      MATCH_OP
      NEQ
      NEWLINE
      ON
      PLUS
      PRIMARY_KEY
      REFERENCES
      RESTRICT
      RPAREN
      SPACE
      STRLIT
      TYPE
      UNIQUE

rule
  constraint      : unique_column   { result = val[0] }
                  | check_statement { result = val[0] }
                  | foreign_key     { result = val[0] }
                  ;

  unique_column   : UNIQUE LPAREN IDENT RPAREN { result = UniqueNode.new(IdentNode.new(val[2])) }
                  ;

  check_statement : CHECK expr  { result = CheckNode.new(val[1]) }

  expr            :                     { result = EmptyExprNode.new :empty }
                  | LPAREN expr RPAREN  { result = ExprNode.new(val[1]) }
                  | expr type_signature { result = TypedExprNode.new(val[0], val[1]) }
                  | expr operator expr  { result = OperatorNode.new(val[1], val[0], val[2]) }
                  | IDENT               { result = IdentNode.new(val[0]) }
                  | STRLIT              { result = StrLitNode.new(val[0]) }
                  | INT                 { result = IntNode.new(val[0]) }
                  ;

  operator        : GTEQ     { result = :gteq  }
                  | LTEQ     { result = :lteq  }
                  | NEQ      { result = :neq   }
                  | EQ       { result = :eq    }
                  | GT       { result = :gt    }
                  | LT       { result = :lt    }
                  | PLUS     { result = :plus  }
                  | MATCH_OP { result = :match }
                  ;

  type_signature  : TYPE IDENT { result = IdentNode.new(val[1]) }
                  ;

  foreign_key     : FOREIGN_KEY column_spec REFERENCES table_spec             { result = ForeignKeyNode.new(val[1], val[3]) }
                  | FOREIGN_KEY column_spec REFERENCES table_spec action_spec { result = ForeignKeyNode.new(val[1], val[3], val[4]) }
                  ;

  column_spec     : LPAREN IDENT RPAREN { result = IdentNode.new(val[1]) }
                  ;

  table_spec      : IDENT column_spec { result = TableNode.new(IdentNode.new(val[0]), val[1]) }
                  ;

  action_spec     : ON DELETE RESTRICT { result = ActionNode.new(:delete, :restrict) }
                  | ON DELETE CASCADE  { result = ActionNode.new(:delete, :cascade) }
                  ;
end

---- inner

  require 'lexer'
  require 'code_generator'

  def initialize tokenizer, handler = nil
    @tokenizer = tokenizer
    super()
  end

  def next_token
    @tokenizer.next_token
  end

  def parse
    do_parse
  end
