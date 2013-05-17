class Node
  attr_accessor :value, :children
  def initialize val
    value = val
  end
end

class UniqueNode < Node
end

class CheckNode < Node
end
