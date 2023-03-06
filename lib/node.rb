# Class for node of binary search tree
class Node
  def initialize(value = nil)
    @value = value
  end
  attr_accessor :value, :left, :right
end