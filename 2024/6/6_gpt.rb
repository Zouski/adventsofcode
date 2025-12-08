class GuardSimulation
  DIRECTIONS = {
    up: [-1, 0],
    right: [0, 1],
    down: [1, 0],
    left: [0, -1]
  }

  def initialize(grid)
    @grid = grid.map(&:chars)
    @start_position, @start_direction = find_start
  end

  def can_loop_with_placement?
    loopable_positions = 0

    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell != "."

        @grid[y][x] = "#"
        loopable_positions += 1 if causes_loop?
        @grid[y][x] = "."
      end
    end

    loopable_positions
  end

  private

  def find_start
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        return [[y, x], :up] if cell == "^"
      end
    end
    raise "No starting position found!"
  end

  def causes_loop?
    position = @start_position.dup
    direction = @start_direction
    visited = Set.new

    loop do
      visited_state = [position, direction]
      return true if visited.include?(visited_state)

      visited.add(visited_state)
      next_position = move(position, direction)

      if out_of_bounds?(next_position)
        return false
      elsif @grid[next_position[0]][next_position[1]] == "#"
        direction = turn_right(direction)
      else
        position = next_position
      end
    end
  end

  def move(position, direction)
    [position[0] + DIRECTIONS[direction][0], position[1] + DIRECTIONS[direction][1]]
  end

  def turn_right(direction)
    case direction
    when :up then :right
    when :right then :down
    when :down then :left
    when :left then :up
    end
  end

  def out_of_bounds?(position)
    position[0] < 0 || position[0] >= @grid.size || position[1] < 0 || position[1] >= @grid[0].size
  end
end

# Example input
grid = File.open('2024/6/6.txt').readlines.map(&:chomp)

simulator = GuardSimulation.new(grid)

s = Time.now
puts simulator.can_loop_with_placement?
pp (Time.now - s).to_i
