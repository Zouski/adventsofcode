input = File.open('2024/16/16.txt').readlines.map(&:chomp)

START_DIR = :E
DIRS = [:N, :S, :E, :W]
def display(input)
  input.each {|i| puts i.join}
end



@board = input.map(&:chars)

def bfs_with_turn_cost
  start_pos, end_pos = find_start_and_end_positions
  directions = { north: [-1, 0], east: [0, 1], south: [1, 0], west: [0, -1] }
  direction_keys = directions.keys

  queue = [[start_pos, :east, 0]] # [current_position, current_direction, cost]
  visited = {}

  until queue.empty?
    current_pos, current_dir, current_cost = queue.shift
    y, x = current_pos

    # Return cost if we've reached the end position
    return current_cost if current_pos == end_pos

    # Skip if already visited with a lower or equal cost
    next if visited[[current_pos, current_dir]] && visited[[current_pos, current_dir]] <= current_cost
    visited[[current_pos, current_dir]] = current_cost

    # Explore neighbors
    directions.each do |dir, (dy, dx)|
      next_pos = [y + dy, x + dx]
      next if oob?(*next_pos) || @board[next_pos[0]][next_pos[1]] == '#'

      # Calculate turn cost
      turn_cost = (dir == current_dir ? 0 : 1000)
      new_cost = current_cost + 1 + turn_cost

      queue << [next_pos, dir, new_cost]
    end

    # Ensure queue is processed in order of lowest cost
    queue.sort_by! { |_, _, cost| cost }
  end

  # Return nil if no path is found
  nil
end

def find_start_and_end_positions
  start = nil
  end_pos = nil

  @board.each_with_index do |row, y|
    row.each_with_index do |char, x|
      start = [y, x] if char == 'S'
      end_pos = [y, x] if char == 'E'
    end
  end

  [start, end_pos]
end

def oob?(y, x)
  y < 0 || y >= @board.size || x < 0 || x >= @board[0].size
end

def bfs_shortest_tiles
  start_pos, end_pos = find_start_and_end_positions
  directions = { north: [-1, 0], east: [0, 1], south: [1, 0], west: [0, -1] }

  queue = [[start_pos, :east, 0]]
  visited = Hash.new(Float::INFINITY)
  all_paths = Hash.new { |h, k| h[k] = [] }
  min_cost = Float::INFINITY

  until queue.empty?
    current_pos, current_dir, current_cost = queue.shift

    if current_pos == end_pos
      min_cost = [min_cost, current_cost].min
      all_paths[current_cost] << current_pos
      next
    end

    next if visited[[current_pos, current_dir]] <= current_cost
    visited[[current_pos, current_dir]] = current_cost

    directions.each do |dir, (dy, dx)|
      next_pos = [current_pos[0] + dy, current_pos[1] + dx]
      next if oob?(*next_pos) || @board[next_pos[0]][next_pos[1]] == '#'

      turn_cost = (dir == current_dir ? 0 : 1000)
      queue << [next_pos, dir, current_cost + 1 + turn_cost]
      all_paths[current_cost + 1 + turn_cost] << next_pos
    end

    queue.sort_by! { |_, _, cost| cost }
  end

  all_paths[min_cost].uniq.size
end


pp bfs_with_turn_cost
pp bfs_shortest_tiles




