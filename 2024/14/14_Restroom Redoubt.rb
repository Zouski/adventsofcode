example = false
if example
  input = File.open('2024/14/14e.txt').readlines.map(&:chomp)
  # input = ["p=2,4 v=2,-3"]
  X = 11
  Y = 7
else
  input = File.open('2024/14/14.txt').readlines.map(&:chomp)
  X = 101
  Y = 103
end

class Guard
  attr_accessor :y, :x, :vy, :vx
  def initialize line
    @x, @y, @vx, @vy = line.scan(/-?\d+/).map(&:to_i)
  end

  def step!
    @x = (@x + @vx) % X
    @y = (@y + @vy) % Y
  end

  def quadrant
    x = @x <=> (X/2)
    y = @y <=> (Y/2)

    # pp "#{@x}, #{@y} is #{x}, #{y}"
    return 0 if x == 0 || y == 0

    case [x, y]
    when [-1, -1]
      return 1
    when [-1, 1]
      return 2
    when [1, -1]
      return 3
    when [1, 1]
      return 4
    else
      raise "what"
    end
  end
end

def display guards
  arr = Array.new(Y) { Array.new(X, 0) }

  guards.each do |guard|
    arr[guard.y][guard.x] += 1
  end

  arr.each do |line|
    pp line.map { |num| num == 0 ? '.' : num.to_s}.join
  end
end

def make guards
  arr = Array.new(Y) { Array.new(X, 0) }

  guards.each do |guard|
    arr[guard.y][guard.x] += 1
  end

  arr
end

pp input
guards = []
quads = [0,0,0,0,0]
input.each do |line|
  guard = Guard.new(line)
  guards << guard
end


pp guards.first
# display guards

guards_two = guards.map { |guard| guard.clone }
100.times do |i|
  guards.map(&:step!)
end

guards.each do |guard|
  quads[guard.quadrant] += 1
end

pp "asd"
# display guards


# pp quads
pp quads[1..].inject(:*)

require 'matrix'

def populate_matrix_with_hash(guards, generation)
  counts = Hash.new(0) # Use a hash to store counts at each position

  guards.each do |guard|
    x, y, vx, vy = guard.x, guard.y, guard.vx, guard.vy
    final_x = (x + (vx * generation)) % X
    final_y = (y + (vy * generation)) % Y

    counts[[final_y, final_x]] += 1 # Increment count in the hash
  end

  # Build the matrix from the hash
  matrix = Matrix.build(Y, X) do |row, col|
    counts[[row, col]] || 0 # Get count from hash or 0 if not present
  end

  matrix
end

def calculate_entropy(matrix)
  rows = matrix.row_count
  cols = matrix.column_count
  total_elements = rows * cols

  # Count the occurrences of each unique value
  value_counts = Hash.new(0)
  matrix.each do |element|
    value_counts[element] += 1
  end

  entropy = 0.0
  value_counts.each_value do |count|
    probability = count.to_f / total_elements
    entropy -= probability * Math.log2(probability) if probability > 0 # Avoid log(0)
  end

  entropy
end

matrix = populate_matrix_with_hash(guards_two, 0)
high = calculate_entropy(matrix)

i = 0
x = 1
gen = 0
10000.times do
  i += 1
  matrix = populate_matrix_with_hash(guards_two, i)
  ent = calculate_entropy(matrix)
  if ent < high
    high = ent
    pp "Record #{i}, #{high}"
    gen = i
  end

  if i == x
    puts i
    x *= 2
  end

  if matrix.all? { |element| element == 0 || element == 1 }
    pp "all #{i}"
  end

end

gen.times do
  guards_two.map(&:step!)
end
pp gen
display guards_two