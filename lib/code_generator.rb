class Node
  def initialize val, *args
    @value = val
    @children = args
  end

  def text_expr
    raise "text_expr is not implemented: #{self}"
  end

  def gen
    raise "gen is not implemented: #{self}"
  end

  def column
    raise "column is not implemented: #{self}"
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
    @value.gen
  end
end

class ExprNode < Node
  def initialize val; super(val); end

  def column
    @value && @value.column
  end

  def text_expr
    @value.text_expr
  end

  def gen
    if @value.nil?
      "true"
    else
      @value.gen
    end
  end
end

class EmptyExprNode < Node
  def gen
    'true'
  end
end

class CheckNode < Node
  def initialize val; super(val); end

  def gen
    column = @value.column || 'base'
    text_expr = @value.text_expr
    val = @value.gen
    if val
      "validate { errors.add(:#{column}, \"Expected #{text_expr}\") unless #{@value.gen} }"
    else
      "validate { true }"
    end
  end
end

class TypedExprNode < Node
  def initialize val, *args
    @children = args
    @type = @children[0]
    @value = case @type.gen
             when 'text' then TextExprNode.new(val)
             when 'date' then DateExprNode.new(val)
             else
               raise "Unknown type: #{@children[0]}"
             end
  end

  def gen
    @value.gen
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
      "Date.parse(#{val})"
    end
  end
end

class TextExprNode < Node
  def initialize val; super(val); end

  def gen
    @value.gen
  end
end

class StrNode < Node
  def initialize val; super(val); end

  def gen
    @value.gsub(/^'(.*)'$/, '\1')
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
    puts "#{@e2.class} #{@e2.gen.class}"
    "#{@e1.gen} =~ /#{convert_wildcard @e2.gen}/"
  end
end
