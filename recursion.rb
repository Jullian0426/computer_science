def fibs(n)
  return [] if n <= 0
  return [0] if n == 1
  
  fib_sequence = [0, 1]
  (n - 2).times do
    fib_sequence << fib_sequence[-1] + fib_sequence[-2]
  end
  fib_sequence
end

def fibs_rec(n, fib_sequence = [0, 1])
  return [] if n <= 0
  return [0] if n == 1
  return fib_sequence[0...n] if fib_sequence.length >= n

  fib_sequence << fib_sequence[-1] + fib_sequence[-2]
  fibs_rec(n, fib_sequence)
end

def merge_sort(array)
  return array if array.length <= 1

  mid = array.length / 2
  left_half = merge_sort(array[0...mid])
  right_half = merge_sort(array[mid..-1])

  merge(left_half, right_half)
end

def merge(left, right)
  sorted_array = []
  until left.empty? || right.empty?
    if left.first <= right.first
      sorted_array << left.shift
    else
      sorted_array << right.shift
    end
  end
  sorted_array + left + right
end

# Testing iterative Fibonacci method
puts "Iterative method:"
puts fibs(8).inspect  # Output should be: [0, 1, 1, 2, 3, 5, 8, 13]

# Testing recursive Fibonacci method
puts "Recursive method:"
puts fibs_rec(8).inspect  # Output should be: [0, 1, 1, 2, 3, 5, 8, 13]

# Testing merge sort
puts "Merge sort:"
puts merge_sort([3, 2, 1, 13, 8, 5, 0, 1]).inspect  # Output should be: [0, 1, 1, 2, 3, 5, 8, 13]
puts merge_sort([105, 79, 100, 110]).inspect       # Output should be: [79, 100, 105, 110]