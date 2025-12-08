input = File.open('2024/6/6.txt').readlines.map(&:chomp)


class Vector
  attr_accessor :y, :x, :dir

  def initialize(y, x, dir)
    @y = y
    @x = x
    @dir = dir
  end

  RIGHT = {
    :^ => :>,
    :> => :v,
    :v => :<,
    :< => :^
  }

  DIR_MAP = {
    :^ => [-1,0],
    :> => [0,1],
    :v => [1,0],
    :< => [0,-1]
  }

  def right!
    @dir = RIGHT[@dir]
  end
  def move!
    @y += DIR_MAP[@dir][0]
    @x += DIR_MAP[@dir][1]
  end

  def ahead
    return Vector.new(@y + DIR_MAP[@dir][0], @x + DIR_MAP[@dir][1], @dir)
  end

  def out
    [@y, @x, @dir]
  end
end

pp input

class Board
  attr_reader :grid, :start
  def initialize(lines)
    @grid = lines.map { |line| line.chars }
    @start = find_start
  end

  def display
    @grid.each { |row| puts row.flatten.join }
  end

  def get(point)
    grid[point.y][point.x]
  end

  def set(point, value)
    grid[point.y][point.x] = value
  end

  def grid_set(y, x, value)
    grid[y][x] = value
  end

  def oob?(point)
    point.y < 0 || point.y >= @grid.length || point.x < 0 || point.x >= @grid.length
  end

  def find_start
    @grid.each_with_index do |line, i|
      line.each_with_index do |char, j|
        return Vector.new(i, j, :^) if char == '^'
      end
    end
  end

  def exes
    count = 0
    @grid.each do |line|
      line.each do |char|
        count += 1 if char == 'X'
      end
    end
    count
  end

  def obstacles
    count = 0
    @grid.each_with_index do |line, i|
      line.each_with_index do |char, j|
        next unless char == 'X'

        grid_set(i, j, '#')
        count += 1 if check_loop
        grid_set(i, j, 'X')
      end
    end
    count
  end

  def check_loop
    visited = Set.new

    place = @start.dup
    loop do
      return true if visited.include?(place.out)
      return false if oob? place.ahead

      visited.add place.out

      if get(place.ahead) == '#'
        place.right!
      else
        place.move!
      end
    end
  end
end

# Example usage:
board = Board.new(input)
board.display

place = board.start.dup

until board.oob? place.ahead
  board.set(place, 'X')
  if board.get(place.ahead) == '#'
    place.right!
  else
    place.move!
  end
end
board.set(place, 'X')

board.display
pp board.exes
board.set(board.start, '^')
s = Time.now
pp board.obstacles
pp (Time.now - s).to_i
