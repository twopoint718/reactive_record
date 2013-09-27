class Node
  def initialize val, *args
    @value = val
    @children = args
  end

  def gen
    raise "gen is not implemented: #{self}"
  end

  def column
    'base'
  end
end

class UniqueNode < Node
  def initialize val; super(val, nil); end

  def gen
    "validates :#{@value.gen}, uniqueness: true"
  end
end

class IdentNode < Node
  def initialize val; super(val, nil); end

  def gen
    # bottoms out: IDENT is a string
    @value
  end

  def column
    # ident is likely a column (must be?)
    @value
  end
end

class ExprNode < Node
  def initialize val; super(val); end

  def column
    @value.column
  end

  def gen
    @value.gen
  end
end

class EmptyExprNode < Node
  def gen
    nil
  end

  def column
    nil
  end
end

class CheckNode < Node
  def initialize val; super(val); end

  def gen
    column = @value.column
    val = @value.gen
    if val
      "validate { errors.add(:#{column}, \"Expected TODO\") unless #{val} }"
    else
      "validate { true }"
    end
  end
end

class TypedExprNode < Node
  def initialize val, *args
    @children = args
    @type = @children[0]
    #raise "value: #{val.gen}, type: #{@children[0]}"
    @value = case @type.gen
             when 'text' then TextNode.new(val)
             when 'date' then DateExprNode.new(val)
             else
               raise "Unknown type: #{@children[0]}"
             end
  end

  def column
    @value.column
  end

  def gen
    @value.gen
  end
end

class TextNode < Node
  def gen
    @value.gen
  end

  def column
    @value.column
  end
end

class DateExprNode < Node
  def initialize val
    @value = val
  end

  def gen
    val = @value.gen
    if val == 'now'
      "Time.now.to_date"
    else
      # YYYY-MM-DD
      "Date.parse(\"#{val}\")"
    end
  end
end

class StrLitNode < Node
  def initialize val; super(val); end

  def gen
    #FIXME HACK
    if @value.respond_to? :gen
      val = @value.gen
    else
      val = @value
    end
    val.gsub(/^'(.*)'$/, '\1')
  end
end

class IntNode < Node
  def initialize val; super(val); end

  def gen
    @value.to_s
  end
end

class OperatorNode < Node
  def initialize op, *args
    @value = op
    @children = args
    @expr1 = @children[0]
    @expr2 = @children[1]
  end

  def operation
    case @value
    when :gteq, :lteq, :neq, :eq, :gt, :lt
      ComparisonExpr.new @value, @expr1, @expr2
    when :plus
      MathExpr.new @value, @expr1, @expr2
    when :match
      MatchExpr.new @expr1, @expr2
    end
  end

  def error_msg
    case @value
    when :gteq  then 'to be greater than or equal to'
    when :lteq  then 'to be less than or equal to'
    when :neq   then 'to not equal'
    when :eq    then 'to be equal to'
    when :gt    then 'to be greater than'
    when :lt    then 'to be less than'
    when :plus  then 'plus'
    when :match then 'to match'
    end
  end

  def column
    c1 = @expr1.column
    c2 = @expr1.column
    return c1 if c1 != 'base'
    return c2 if c2 != 'base'
    'base'
  end

  def gen
    operation.gen
  end
end

class ComparisonExpr
  def initialize comparison, e1, e2
    @e1, @e2 = e1, e2
    @comparison = {
      gteq: '>=',
      lteq: '<=',
      neq: '!=',
      eq: '==',
      gt: '>',
      lt: '<',
    }[comparison]
  end

  def gen
    "#{@e1.gen} #{@comparison} #{@e2.gen}"
  end
end

class MathExpr
  def initialize op, e1, e2
    @e1, @e2 = e1, e2
    @operation = { plus: '+', minus: '-' }[op]
  end

  def gen
    "#{@e1.gen} #{@operation} #{@e2.gen}"
  end
end

class MatchExpr
  def initialize e1, e2
    @e1 = e1
    @e2 = e2
  end

  def convert_wildcard str
    str.gsub(/%/, '.*')
  end

  def gen
    #raise "RHS: #{@e2.class} #{@e2.gen.class}"
    "#{@e1.gen} =~ /#{convert_wildcard @e2.gen}/"
  end
end

class TableNode < Node
  def initialize tab, col
    @tab = tab
    @col = col
  end

  def table_to_class
    @tab.gen.capitalize
  end

  def key_name
    @col.gen
  end

  def gen
    @tab.gen
  end
end

class ActionNode < Node
  def initialize action, consequence
    @action = action
    @consequence = consequence
  end

  def gen
    "ON #{@action} #{@consequence}"
  end
end

class ForeignKeyNode < Node
  def initialize col, table, *actions
    @col = col
    @table = table
    if actions.count > 0
      @action = actions[0]
    end
  end

  def gen
    col = @col.gen
    table_name = @table.gen
    class_name = @table.table_to_class
    key = @table.key_name
    "belongs_to :#{table_name}, foreign_key: '#{col}', class: '#{class_name}', primary_key: '#{key}'"
  end
end
