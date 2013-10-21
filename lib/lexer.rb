require 'strscan'

module ConstraintParser
  class Lexer
    AND         = /AND/
    CASCADE     = /CASCADE/
    CHECK       = /CHECK/
    COMMA       = /,/
    DELETE      = /DELETE/
    EQ          = /\=/
    FOREIGN_KEY = /FOREIGN KEY/
    GT          = /\>/
    GTEQ        = /\>=/
    IDENT       = /[a-zA-Z][a-zA-Z0-9_]*/
    INT         = /[0-9]+/
    LPAREN      = /\(/
    LT          = /\</
    LTEQ        = /\<=/
    MATCH_OP    = /~~/
    NEQ         = /\<\>/
    NEWLINE     = /\n/
    ON          = /ON/
    PLUS        = /\+/
    PRIMARY_KEY = /PRIMARY KEY/
    REFERENCES  = /REFERENCES/
    RESTRICT    = /RESTRICT/
    RPAREN      = /\)/
    SPACE       = /[\ \t]+/
    STRLIT      = /\'(\\.|[^\\'])*\'/
    TYPE        = /::/
    UNIQUE      = /UNIQUE/

    def initialize io
      @ss = StringScanner.new io.read
    end

    def next_token
      return if @ss.eos?

      result = false
      while !result
        result = case
          when text = @ss.scan(SPACE)       then #ignore whitespace

          # Operators
          when text = @ss.scan(GTEQ)        then [:GTEQ, text]
          when text = @ss.scan(LTEQ)        then [:LTEQ, text]
          when text = @ss.scan(NEQ)         then [:NEQ, text]
          when text = @ss.scan(GT)          then [:GT, text]
          when text = @ss.scan(LT)          then [:LT, text]
          when text = @ss.scan(EQ)          then [:EQ, text]
          when text = @ss.scan(PLUS)        then [:PLUS, text]
          when text = @ss.scan(MATCH_OP)    then [:MATCH_OP, text]
          when text = @ss.scan(AND)         then [:AND, text]

          # SQL Keywords
          when text = @ss.scan(CHECK)       then [:CHECK, text]
          when text = @ss.scan(UNIQUE)      then [:UNIQUE, text]
          when text = @ss.scan(PRIMARY_KEY) then [:PRIMARY_KEY, text]
          when text = @ss.scan(FOREIGN_KEY) then [:FOREIGN_KEY, text]
          when text = @ss.scan(REFERENCES)  then [:REFERENCES, text]
          when text = @ss.scan(DELETE)      then [:DELETE, text]
          when text = @ss.scan(ON)          then [:ON, text]
          when text = @ss.scan(RESTRICT)    then [:RESTRICT, text]
          when text = @ss.scan(CASCADE)     then [:CASCADE, text]

          # Values
          when text = @ss.scan(IDENT)       then [:IDENT, text]
          when text = @ss.scan(STRLIT)      then [:STRLIT, text]
          when text = @ss.scan(INT)         then [:INT, text]

          # Syntax
          when text = @ss.scan(LPAREN)      then [:LPAREN, text]
          when text = @ss.scan(RPAREN)      then [:RPAREN, text]
          when text = @ss.scan(TYPE)        then [:TYPE, text]
          when text = @ss.scan(COMMA)       then [:COMMA, text]
          else
            x = @ss.getch
            [x, x]
        end
      end
      result
    end

    def tokenize
      out = []
      while (tok = next_token)
        out << tok
      end
      out
    end
  end
end
