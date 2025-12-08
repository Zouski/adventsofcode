input = File.open('2024/6/6e.txt').readlines.map(&:chomp)

pp input

Point = Struct.new(:y, :x) do
  def add(other)
    Point.new(self.y + other.y, self.x + other.x)
  end
end
class Board
  attr_accessor :obstacles, :board

  def initialize(input, start = nil, start_dir = nil)
    @obstacles = 0
    @right = {
      :^ => :>,
      :> => :v,
      :v => :<,
      :< => :^
    }

    @direction_map = {
      :^ => Point.new(-1, 0),
      :> => Point.new(0,1),
      :v => Point.new(1,0),
      :< => Point.new(0,-1)
    }

    if input.first.class == String
      @board = input.map do |line|
        line.split('')
      end
    else
      @board = input.map(&:dup)
    end


    if start.nil?
      @board.each_with_index do |line, i|
        if line.include? '^'
          @point = Point.new(i, line.index('^') )
          @direction = @direction_map[:^]
          @direction_sym = :^
          break
        end
      end
    else
      @point = start
      @direction_sym = start_dir
      @direction = @direction_map[start_dir]
    end
  end

  def display
    @board.each do |line|
      pp line.join
    end
  end

  def turn_right!
    @direction_sym = @right[@direction_sym]
    @direction = @direction_map[@direction_sym]
  end

  def sim_forward!
    char = @direction_sym.to_s

    cur = set(@point, char)
    if cur != '.'
      #set(@point, '+')
    end

    if cur == @direction_sym.to_s
      puts "got a hit"
      return 2
    end

    @point = @point.add @direction
    1
  end
  def go_forward!
    char = @direction_sym.to_s

    cur = set(@point, char)
    if cur != '.'
      #set(@point, '+')
    end

    @point = @point.add @direction
    1
  end

  def set(point, value)
    return nil if point.y < 0 || point.x < 0 || point.y >= @board.length || point.x >= @board.length

    old = @board[point.y][point.x]
    @board[point.y][point.x] = value
    old
  end

  def get(point)
    return nil if point.y < 0 || point.x < 0 || point.y >= @board.length || point.x >= @board.length
    @board[point.y][point.x]
  end

  def baby_step
    facing = get(@point.add @direction)
    return -1 if facing.nil?

    if facing == '#'
      turn_right!
    else
      result = sim_forward!
    end

    if result == 2
      return 2
    end

    1
  end

  def step
    facing = get(@point.add @direction)
    return -1 if facing.nil?

    if facing == '#'
      turn_right!
    else
      inner = Board.new(@board, @point, @right[@direction_sym])
      inner.set(@point.add(@direction), '#')
      done = 1

      count = 0
      while done == 1
        done = inner.baby_step
        count += 1
      end

      puts "board"
      display

      if done == 2
        @obstacles += 1
      end

      pp @obstacles

      go_forward!
    end

    1
  end

  def at(point)
    @board[point.y][point.x]
  end


  def count
    c = 0
    @board.each do |line|
      line.each do |char|
        c += 1 unless ['#', '.'].include? char
      end
    end
    c + 1
  end
end

board = Board.new(input)
board.display

done = 1
obstacles = 0
until done == -1
  done = board.step
end

puts "af"

board.display

pp board.count
pp board.obstacles