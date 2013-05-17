class ConstraintParser::Parser
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
  constraint      : unique_column
                  | check_statement
                  ;

  unique_column   : UNIQUE LPAREN IDENT RPAREN
                  ;

  check_statement : CHECK expr

  expr            : # empty expression
                  | LPAREN expr RPAREN
                  | operand operator operand
                  ;

  operator        : GTEQ | LTEQ | NEQ | EQ | GT | LT | PLUS | MATCH_OP ;

  operand         : untyped_operand
                  | typed_operand
                  ;

  untyped_operand : LPAREN operand RPAREN
                  | IDENT
                  | STRLIT
                  | INT
                  ;

  typed_operand   : operand type_signature ;

  type_signature  : TYPE IDENT ;
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
