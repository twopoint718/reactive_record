#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'
module ConstraintParser
  class Parser < Racc::Parser


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
##### State transition tables begin ###

racc_action_table = [
    27,    28,    21,    22,    23,    24,    25,    26,    27,    28,
    21,    22,    23,    24,    25,    26,    27,    28,    21,    22,
    23,    24,    25,    26,    29,     6,    45,    35,     7,    12,
    14,    11,    29,    12,    14,    11,    31,    36,    44,    13,
    29,     5,    32,    13,    12,    14,    11,    16,    18,    17,
     9,    38,    39,     8,    13,    41,    16,    43,    33 ]

racc_action_check = [
    10,    10,    10,    10,    10,    10,    10,    10,    34,    34,
    34,    34,    34,    34,    34,    34,    30,    30,    30,    30,
    30,    30,    30,    30,    10,     0,    43,    29,     0,    11,
    11,    11,    34,    20,    20,    20,    15,    30,    43,    11,
    30,     0,    16,    20,     6,     6,     6,     7,     9,     8,
     5,    31,    32,     1,     6,    37,    38,    41,    18 ]

racc_action_pointer = [
    14,    53,   nil,   nil,   nil,    33,    29,    30,    49,    33,
    -2,    14,   nil,   nil,   nil,    15,    27,   nil,    35,   nil,
    18,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    12,
    14,    36,    29,   nil,     6,   nil,   nil,    36,    39,   nil,
   nil,    44,   nil,    16,   nil,   nil ]

racc_action_default = [
   -28,   -28,    -1,    -2,    -3,   -28,    -6,   -28,   -28,   -28,
    -5,    -6,   -10,   -11,   -12,   -28,   -28,    46,   -28,    -8,
    -6,   -13,   -14,   -15,   -16,   -17,   -18,   -19,   -20,   -28,
   -28,   -28,   -28,    -4,    -9,   -21,    -7,   -22,   -28,   -24,
   -23,   -28,   -25,   -28,   -26,   -27 ]

racc_goto_table = [
    15,    10,     1,     4,     3,     2,    30,    37,    40,   nil,
   nil,   nil,   nil,   nil,   nil,    34,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    42 ]

racc_goto_check = [
     8,     5,     1,     4,     3,     2,     5,     9,    10,   nil,
   nil,   nil,   nil,   nil,   nil,     5,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     8 ]

racc_goto_pointer = [
   nil,     2,     5,     4,     3,    -5,   nil,   nil,    -7,   -24,
   -29 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,    19,    20,   nil,   nil,
   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 29, :_reduce_1,
  1, 29, :_reduce_2,
  1, 29, :_reduce_3,
  4, 30, :_reduce_4,
  2, 31, :_reduce_5,
  0, 33, :_reduce_6,
  3, 33, :_reduce_7,
  2, 33, :_reduce_8,
  3, 33, :_reduce_9,
  1, 33, :_reduce_10,
  1, 33, :_reduce_11,
  1, 33, :_reduce_12,
  1, 35, :_reduce_13,
  1, 35, :_reduce_14,
  1, 35, :_reduce_15,
  1, 35, :_reduce_16,
  1, 35, :_reduce_17,
  1, 35, :_reduce_18,
  1, 35, :_reduce_19,
  1, 35, :_reduce_20,
  2, 34, :_reduce_21,
  4, 32, :_reduce_22,
  5, 32, :_reduce_23,
  3, 36, :_reduce_24,
  2, 37, :_reduce_25,
  3, 38, :_reduce_26,
  3, 38, :_reduce_27 ]

racc_reduce_n = 28

racc_shift_n = 46

racc_token_table = {
  false => 0,
  :error => 1,
  :PLUS => 2,
  :MATCH_OP => 3,
  :GTEQ => 4,
  :LTEQ => 5,
  :NEQ => 6,
  :EQ => 7,
  :GT => 8,
  :LT => 9,
  :CASCADE => 10,
  :CHECK => 11,
  :COMMA => 12,
  :DELETE => 13,
  :FOREIGN_KEY => 14,
  :IDENT => 15,
  :INT => 16,
  :LPAREN => 17,
  :NEWLINE => 18,
  :ON => 19,
  :PRIMARY_KEY => 20,
  :REFERENCES => 21,
  :RESTRICT => 22,
  :RPAREN => 23,
  :SPACE => 24,
  :STRLIT => 25,
  :TYPE => 26,
  :UNIQUE => 27 }

racc_nt_base = 28

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "PLUS",
  "MATCH_OP",
  "GTEQ",
  "LTEQ",
  "NEQ",
  "EQ",
  "GT",
  "LT",
  "CASCADE",
  "CHECK",
  "COMMA",
  "DELETE",
  "FOREIGN_KEY",
  "IDENT",
  "INT",
  "LPAREN",
  "NEWLINE",
  "ON",
  "PRIMARY_KEY",
  "REFERENCES",
  "RESTRICT",
  "RPAREN",
  "SPACE",
  "STRLIT",
  "TYPE",
  "UNIQUE",
  "$start",
  "constraint",
  "unique_column",
  "check_statement",
  "foreign_key",
  "expr",
  "type_signature",
  "operator",
  "column_spec",
  "table_spec",
  "action_spec" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

def _reduce_1(val, _values, result)
 result = val[0] 
    result
end

def _reduce_2(val, _values, result)
 result = val[0] 
    result
end

def _reduce_3(val, _values, result)
 result = val[0] 
    result
end

def _reduce_4(val, _values, result)
 result = UniqueNode.new(IdentNode.new(val[2])) 
    result
end

def _reduce_5(val, _values, result)
 result = CheckNode.new(val[1]) 
    result
end

def _reduce_6(val, _values, result)
 result = EmptyExprNode.new :empty 
    result
end

def _reduce_7(val, _values, result)
 result = ExprNode.new(val[1]) 
    result
end

def _reduce_8(val, _values, result)
 result = TypedExprNode.new(val[0], val[1]) 
    result
end

def _reduce_9(val, _values, result)
 result = OperatorNode.new(val[1], val[0], val[2]) 
    result
end

def _reduce_10(val, _values, result)
 result = IdentNode.new(val[0]) 
    result
end

def _reduce_11(val, _values, result)
 result = StrLitNode.new(val[0]) 
    result
end

def _reduce_12(val, _values, result)
 result = IntNode.new(val[0]) 
    result
end

def _reduce_13(val, _values, result)
 result = :gteq  
    result
end

def _reduce_14(val, _values, result)
 result = :lteq  
    result
end

def _reduce_15(val, _values, result)
 result = :neq   
    result
end

def _reduce_16(val, _values, result)
 result = :eq    
    result
end

def _reduce_17(val, _values, result)
 result = :gt    
    result
end

def _reduce_18(val, _values, result)
 result = :lt    
    result
end

def _reduce_19(val, _values, result)
 result = :plus  
    result
end

def _reduce_20(val, _values, result)
 result = :match 
    result
end

def _reduce_21(val, _values, result)
 result = IdentNode.new(val[1]) 
    result
end

def _reduce_22(val, _values, result)
 result = ForeignKeyNode.new(val[1], val[3]) 
    result
end

def _reduce_23(val, _values, result)
 result = ForeignKeyNode.new(val[1], val[3], val[4]) 
    result
end

def _reduce_24(val, _values, result)
 result = IdentNode.new(val[1]) 
    result
end

def _reduce_25(val, _values, result)
 result = TableNode.new(IdentNode.new(val[0]), val[1]) 
    result
end

def _reduce_26(val, _values, result)
 result = ActionNode.new(:delete, :restrict) 
    result
end

def _reduce_27(val, _values, result)
 result = ActionNode.new(:delete, :cascade) 
    result
end

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class Parser
  end   # module ConstraintParser