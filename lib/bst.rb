require_relative 'node'
# Class for binary search tree
class Tree
  def initialize(array)
    @user_data = array
  end
  attr_accessor :root

  def sorted_array
    @user_data.sort.uniq
  end

  def build_tree(data = sorted_array)
    return nil if data.empty?
    return Node.new(data[0]) if data.length == 1
    halve = (data.length / 2).floor
    root = Node.new(data[halve])
    root.left = build_tree(data.take(halve))
    root.right = build_tree(data.pop(data.length - halve - 1))
    @root = root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(input)
    recursive_search(input) do |node, previous_node, direction|
      if node.nil?
        return previous_node.right = Node.new(input) if direction == 'right'
        return previous_node.left = Node.new(input) if direction == 'left'
      end
      return 'Value is present in the tree.' if input == node.value
    end
  end

  def delete(input)
    recursive_search(input) do |node, previous_node, direction|
      return 'No such value in the tree.' if node.nil?

      if input == node.value
        return previous_node.left = nil if direction == 'left'
        return previous_node.right = nil if direction == 'right'
      end
    end
  end

  def find(input)
    recursive_search(input) do |node|
      return 'Value not found.' if node.nil?
      return node if input == node.value
    end
  end

  def level_order
    queue = []
    ary = []
    node = @root
    loop do
      queue << node.left if node.left
      queue << node.right if node.right
      block_given? ? yield(node) : ary << node.value 
      break if queue.empty?

      node = queue.shift
    end
    ary unless block_given?
  end

  def inorder(node = @root, ary = [], &block)
    if node.left.nil?
      block_given? ? block.call(node) : ary << node.value
    else
      inorder(node.left, ary, &block)
      block_given? ? block.call(node) : ary << node.value
      inorder(node.right, ary, &block) if node.right
      ary unless block_given?
    end
  end

  def preorder
    queue = []
    ary = []
    node = @root
    loop do
      block_given? ? yield(node) : ary << node.value
      queue.unshift(node.right) if node.right
      queue.unshift(node.left) if node.left
      break if queue.empty?

      node = queue.shift
    end
    ary unless block_given?
  end

  def postorder(node = @root, ary = [], &block)
    if node.left.nil?
      block_given? ? block.call(node) : ary << node.value
    else
      postorder(node.left, ary, &block)
      postorder(node.right, ary, &block) if node.right
      block_given? ? block.call(node) : ary << node.value
      ary unless block_given?
    end
  end

  def height(node_input, edges = 0, stored_heights = [])
    if node_input.left.nil? && node_input.right.nil?
      stored_heights << edges
      edges
    else
      height(node_input.left, edges + 1, stored_heights) if node_input.left
      height(node_input.right, edges + 1, stored_heights) if node_input.right
      stored_heights.max.to_i
    end
  end

  def depth(node_input)
    edges = 0
    recursive_search(node_input.value) do |node|
      return edges if node_input.value == node.value
      edges += 1
    end
  end

  def balanced?(node = @root)
    if node.left.nil? && node.right.nil?
      true
    else
      left_height = node.left ? height(node.left) + 1 : 0
      right_height = node.right ? height(node.right) + 1 : 0
      difference = (left_height - right_height).abs
      return false if difference > 1
      balanced?(node.left) if node.left
      balanced?(node.right) if node.right
    end
  end

  def rebalance
    build_tree(preorder)
  end

  private

  def recursive_search(input, node = @root, previous_node = nil, direction = nil, &addon)
    addon.call(node, previous_node, direction) if block_given?

    input > node.value ? recursive_search(input, node.right, node, 'right', &addon) : recursive_search(input, node.left, node, 'left', &addon)
  end
end

t = Tree.new((Array.new(15) { rand(1..100) }))
t.build_tree
t.pretty_print
p t.balanced?
p t.level_order
p t.inorder
p t.preorder
p t.postorder
t.insert(130)
t.insert(141)
t.insert(200)
p t.balanced?
t.rebalance
t.pretty_print
p t.balanced?
