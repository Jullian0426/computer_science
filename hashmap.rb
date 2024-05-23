class Node
  attr_accessor :key, :value, :next_node

  def initialize(key, value)
    @key = key
    @value = value
    @next_node = nil
  end
end

class HashMap
  attr_accessor :buckets, :size

  def initialize
    @buckets = Array.new(16) { nil }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  def set(key, value)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length
    if @buckets[index].nil?
      @buckets[index] = Node.new(key, value)
    else
      current = @buckets[index]
      while current
        if current.key == key
          current.value = value
          return
        end
        current = current.next_node
      end
      new_node = Node.new(key, value)
      new_node.next_node = @buckets[index]
      @buckets[index] = new_node
    end
    @size += 1
    resize if load_factor > 0.7
  end

  def get(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length
    current = @buckets[index]
    while current
      return current.value if current.key == key
      current = current.next_node
    end
    nil
  end

  def has_key?(key)
    !get(key).nil?
  end

  def remove(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length
    current = @buckets[index]
    prev = nil
    while current
      if current.key == key
        if prev.nil?
          @buckets[index] = current.next_node
        else
          prev.next_node = current.next_node
        end
        @size -= 1
        return current.value
      end
      prev = current
      current = current.next_node
    end
    nil
  end

  def length
    @size
  end

  def clear
    @buckets = Array.new(16) { nil }
    @size = 0
  end

  def keys
    all_nodes.map(&:key)
  end

  def values
    all_nodes.map(&:value)
  end

  def entries
    all_nodes.map { |node| [node.key, node.value] }
  end

  private

  def all_nodes
    nodes = []
    @buckets.each do |bucket|
      current = bucket
      while current
        nodes << current
        current = current.next_node
      end
    end
    nodes
  end

  def load_factor
    @size.to_f / @buckets.length
  end

  def resize
    new_buckets = Array.new(@buckets.length * 2) { nil }
    @buckets.each do |bucket|
      current = bucket
      while current
        index = current.key.hash % new_buckets.length
        if new_buckets[index].nil?
          new_buckets[index] = Node.new(current.key, current.value)
        else
          new_node = Node.new(current.key, current.value)
          new_node.next_node = new_buckets[index]
          new_buckets[index] = new_node
        end
        current = current.next_node
      end
    end
    @buckets = new_buckets
  end
end

hash_map = HashMap.new
hash_map.set('name', 'John')
hash_map.set('age', 30)
hash_map.set('city', 'New York')

puts hash_map.get('name') # => John
puts hash_map.get('age') # => 30
puts hash_map.get('city') # => New York
puts hash_map.get('country') # => nil

hash_map.remove('city')
puts hash_map.get('city') # => nil

puts hash_map.length # => 2

hash_map.clear
puts hash_map.length # => 0

hash_map.set('name', 'John')
hash_map.set('age', 30)

puts hash_map.keys.inspect # => ["name", "age"]
puts hash_map.values.inspect # => ["John", 30]
puts hash_map.entries.inspect # => [["name", "John"], ["age", 30]]

puts hash_map.has_key?('name') # => true
puts hash_map.has_key?('city') # => false