class ConstraintLexer
rule
  [\space\t]+             # no action
  CHECK                   { [:CHECK,    text] ; print 'CHECK '}
  [a-zA-Z][a-zA-Z0-9]*    { [:IDENT,    text] ; print "IDENT(#{text}) " }
  \'(\\.|[^\\'])*\'       { [:STR_LIT,  text] ; print "STR_LIT(#{text}) "}
  ~~                      { [:MATCH,    text] ; print 'MATCH '}
  \:\:                    { [:TYPE_SIG, text] ; print "TYPE_SIG "}
  \>=                     { [:GTEQ,     text] ; print ">= "}
  \<=                     { [:LTEQ,     text] ; print "<="}
  \<\>                    { [:NEQ,      text] ; print "<>"}
  \=                      { [:EQ,       text] ; print "="}
  \>                      { [:GT,       text] ; print ">"}
  \<                      { [:LT,       text] ; print "<"}
  \(                      { [:LPAREN,   text] ; print "LPAREN "}
  \)                      { [:RPAREN,   text] ; print "RPAREN "}
  \n
end
