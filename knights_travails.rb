class Knight
  def initialize
    @moves = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ]
  end

  def valid_move?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def knight_moves(start, target)
    return [start] if start == target

    queue = [[start]]
    visited = Array.new(8) { Array.new(8, false) }
    visited[start[0]][start[1]] = true

    until queue.empty?
      path = queue.shift
      current = path.last

      @moves.each do |move|
        x, y = current[0] + move[0], current[1] + move[1]

        if valid_move?(x, y) && !visited[x][y]
          new_path = path + [[x, y]]
          return new_path if [x, y] == target

          queue << new_path
          visited[x][y] = true
        end
      end
    end
  end
end

# Driver code
def knight_moves(start, target)
  knight = Knight.new
  path = knight.knight_moves(start, target)
  puts "You made it in #{path.length - 1} moves! Here's your path:"
  path.each { |move| p move }
end

# Test cases
knight_moves([3, 3], [4, 3])
knight_moves([0, 0], [1, 2])
knight_moves([3, 3], [0, 0])
knight_moves([0, 0], [7, 7])