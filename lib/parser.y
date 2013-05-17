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
  constraint      : unique_column   { val[0] }
                  | check_statement { val[0] }
                  | foreign_key     { val[0] }
                  ;

  unique_column   : UNIQUE LPAREN IDENT RPAREN { result = [:unique, [:ident, val[2]]] }
                  ;

  check_statement : CHECK expr  { result = [:check, val[1]] }

  expr            : # empty expression
                  | LPAREN expr RPAREN  { result = val[1] }
                  | expr type_signature { result = [:type, val[1], val[0]] }
                  | expr operator expr  { result = [val[1], val[0], val[2]] }
                  | IDENT               { result = [:ident, val[0]] }
                  | STRLIT              { result = eval(val[0]) }
                  | INT                 { result = val[0].to_i }
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

  type_signature  : TYPE IDENT { result = val[1].to_sym }
                  ;

  foreign_key     : FOREIGN_KEY column_spec REFERENCES table_spec
                  | FOREIGN_KEY column_spec REFERENCES table_spec action_spec
                  ;

  column_spec     : LPAREN IDENT RPAREN ;

  table_spec      : IDENT LPAREN IDENT RPAREN ;

  action_spec     : ON DELETE RESTRICT
                  | ON DELETE CASCADE
                  ;
end

---- inner

  require 'lexer'

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
