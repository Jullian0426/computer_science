class Node
  attr_accessor :value, :next_node

  def initialize(value = nil)
    @value = value
    @next_node = nil
  end
end

class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def append(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
    else
      current = @head
      current = current.next_node until current.next_node.nil?
      current.next_node = new_node
    end
  end

  def prepend(value)
    new_node = Node.new(value)
    new_node.next_node = @head
    @head = new_node
  end

  def size
    count = 0
    current = @head
    until current.nil?
      count += 1
      current = current.next_node
    end
    count
  end

  def head_value
    @head.nil? ? nil : @head.value
  end

  def tail_value
    return nil if @head.nil?
    current = @head
    current = current.next_node until current.next_node.nil?
    current.value
  end

  def at(index)
    current = @head
    count = 0
    until current.nil?
      return current if count == index
      count += 1
      current = current.next_node
    end
    nil
  end

  def pop
    return nil if @head.nil?
    if @head.next_node.nil?
      @head = nil
    else
      current = @head
      current = current.next_node until current.next_node.next_node.nil?
      current.next_node = nil
    end
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value
      current = current.next_node
    end
    false
  end

  def find(value)
    current = @head
    index = 0
    until current.nil?
      return index if current.value == value
      index += 1
      current = current.next_node
    end
    nil
  end

  def to_s
    result = ""
    current = @head
    until current.nil?
      result += "( #{current.value} ) -> "
      current = current.next_node
    end
    result += "nil"
  end

  def insert_at(value, index)
    return prepend(value) if index == 0
    current = @head
    (index - 1).times do
      return nil if current.nil?
      current = current.next_node
    end
    new_node = Node.new(value)
    new_node.next_node = current.next_node
    current.next_node = new_node
  end

  def remove_at(index)
    return nil if @head.nil?
    if index == 0
      @head = @head.next_node
    else
      current = @head
      (index - 1).times do
        return nil if current.nil?
        current = current.next_node
      end
      return nil if current.next_node.nil?
      current.next_node = current.next_node.next_node
    end
  end
end

list = LinkedList.new
list.append(1)
list.append(2)
list.append(3)
list.prepend(0)
puts list.to_s # => ( 0 ) -> ( 1 ) -> ( 2 ) -> ( 3 ) -> nil
puts list.size # => 4
puts list.head_value # => 0
puts list.tail_value # => 3
puts list.at(2).value # => 2
list.pop
puts list.to_s # => ( 0 ) -> ( 1 ) -> ( 2 ) -> nil
puts list.contains?(2) # => true
puts list.find(1) # => 1
list.insert_at(1.5, 2)
puts list.to_s # => ( 0 ) -> ( 1 ) -> ( 1.5 ) -> ( 2 ) -> nil
list.remove_at(1)
puts list.to_s # => ( 0 ) -> ( 1.5 ) -> ( 2 ) -> nil