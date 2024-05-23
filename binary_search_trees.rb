class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.size / 2
    root = Node.new(array[mid])

    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[(mid + 1)..-1])

    root
  end

  def insert(value, node = @root)
    return @root = Node.new(value) if node.nil?

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif value > node.data
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      min_larger_node = find_min(node.right)
      node.data = min_larger_node.data
      node.right = delete(min_larger_node.data, node.right)
    end
    node
  end

  def find_min(node)
    node = node.left until node.left.nil?
    node
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root, &block)
    return if node.nil?

    queue = [node]
    values = []

    until queue.empty?
      current = queue.shift
      block_given? ? block.call(current) : values << current.data
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end

    values unless block_given?
  end

  def inorder(node = @root, values = [], &block)
    return if node.nil?

    inorder(node.left, values, &block)
    block_given? ? block.call(node) : values << node.data
    inorder(node.right, values, &block)

    values unless block_given?
  end

  def preorder(node = @root, values = [], &block)
    return if node.nil?

    block_given? ? block.call(node) : values << node.data
    preorder(node.left, values, &block)
    preorder(node.right, values, &block)

    values unless block_given?
  end

  def postorder(node = @root, values = [], &block)
    return if node.nil?

    postorder(node.left, values, &block)
    postorder(node.right, values, &block)
    block_given? ? block.call(node) : values << node.data

    values unless block_given?
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  def depth(node, current = @root, depth = 0)
    return -1 if current.nil?
    return depth if current == node

    left_depth = depth(node, current.left, depth + 1)
    right_depth = depth(node, current.right, depth + 1)

    [left_depth, right_depth].max
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    (left_height - right_height).abs <= 1 &&
      balanced?(node.left) &&
      balanced?(node.right)
  end

  def rebalance
    values = inorder
    @root = build_tree(values)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# Driver script
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
tree.pretty_print
puts "Balanced? #{tree.balanced?}"

puts "Level Order: #{tree.level_order}"
puts "Inorder: #{tree.inorder}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"

# Unbalance the tree
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.pretty_print
puts "Balanced? #{tree.balanced?}"

# Rebalance the tree
tree.rebalance
tree.pretty_print
puts "Balanced? #{tree.balanced?}"

puts "Level Order: #{tree.level_order}"
puts "Inorder: #{tree.inorder}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"