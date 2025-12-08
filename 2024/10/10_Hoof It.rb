input = File.open('2024/10/10.txt').readlines.map(&:chomp)
pp input

board = input.map {|line| line.chars.map(&:to_i)}

@board = board.map(&:dup)
@size = @board.length

DIRECTIONS = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1]
]
def start(y, x, height)
  if height == 9
    @board[y][x] = -1
    return 1
  end

  routes = 0
  DIRECTIONS.each do |direction|
    y1 = y + direction.first
    x1 = x + direction.last

    next if y1 < 0 || y1 >= @size || x1 < 0 || x1 >= @size

    routes += start(y1, x1, height+1) if @board[y1][x1] == height + 1
  end
  routes
end

def step(y, x, height)
  if height == 9
    return 1
  end

  routes = 0
  DIRECTIONS.each do |direction|
    y1 = y + direction.first
    x1 = x + direction.last

    next if y1 < 0 || y1 >= @size || x1 < 0 || x1 >= @size

    routes += step(y1, x1, height+1) if @board[y1][x1] == height + 1
  end
  routes
end


routes = 0
board.each_with_index do |line, i|
  line.each_with_index do |num, j|
    next if num!= 0

    @board = board.map(&:dup)
    routes += start(i, j, 0)
  end
end
pp routes

@board = board.map(&:dup)
routes = 0
board.each_with_index do |line, i|
  line.each_with_index do |num, j|
    next if num!= 0
    routes += step(i, j, 0)
  end
end

pp routes
