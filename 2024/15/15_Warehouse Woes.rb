example = false
if example
  input = File.open('2024/15/15e.txt').readlines.map(&:chomp)
else
  input = File.open('2024/15/15.txt').readlines.map(&:chomp)
end

board_string = input[..input.index("") - 1]
instructions = input[input.index("") + 1..].join

DIRS = {
  "^" => [-1, 0],
  "<" => [0, -1],
  "v" => [1, 0],
  ">" => [0, 1]
}

BOX = %w([ ])
HORZ = %w(< >)
VERT = %w(^ v)
OPP = {
  '[' => ']',
  ']' => '['
}
BOX_DIR = {
  '[' => 1,
  ']' => -1
}

class Board
  attr_reader :grid, :rows, :cols, :y, :x

  def initialize(input)
    @grid = input.map(&:chars)
    @rows = @grid.size
    @cols = @grid.first.size
    @grid.each_with_index do |line, i|
      next unless line.include? '@'
      @y = i
      @x = line.index('@')
      @grid[@y][@x] = '.'
    end
  end

  def oob?(y, x)
    y < 0 || y >= @rows || x < 0 || x >= @cols
  end

  def get(y, x)
    return nil if oob?(y, x)
    @grid[y][x]
  end

  def set(y, x, value)
    return nil if oob?(y, x)
    @grid[y][x] = value
  end

  def to_s
    @grid[@y][@x] = '@'
    output = @grid.map(&:join).join("\n")
    @grid[@y][@x] = '.'
    output
  end

  def step(dir)
    look = ahead(dir)
    if look == '.'
      @y += DIRS[dir][0]
      @x += DIRS[dir][1]
      return 1
    end

    return 0 if look == '#'

    count = 1
    until look != 'O'
      count += 1
      look = ahead(dir, count)
    end

    return 0 if look == '#'

    @grid[@y + (DIRS[dir][0] * count)][@x + (DIRS[dir][1] * count)] = 'O'
    count = 1
    @grid[@y + (DIRS[dir][0] * count)][@x + (DIRS[dir][1] * count)] = '.'
    @y += DIRS[dir][0]
    @x += DIRS[dir][1]
    return 2
  end

  def ahead(dir, count = 1)
    return nil if oob?(@y + (DIRS[dir][0] * count), @x + (DIRS[dir][1] * count))
    @grid[@y + (DIRS[dir][0] * count)][@x + (DIRS[dir][1] * count)]
  end

  def gps
    sum = 0
    @grid.each_with_index do |line, i|
      line.each_with_index do |char, j|
        sum += (i * 100) + j if char == 'O'
      end
    end

    sum
  end
end

class Grid
  attr_reader :grid, :rows, :cols

  def initialize(input)
    # Expand each character into the appropriate representation
    @grid = input.map do |line|
      line = line.chars.map do |char|
        case char
        when '#' then '##'.chars
        when 'O' then '[]'.chars
        when '.' then '..'.chars
        when '@' then '@.'.chars
        else
          raise ArgumentError, "Invalid character in input: #{char}"
        end
      end
      line.flatten
    end
    @rows = @grid.size
    @cols = @grid.first.size
    @grid.each_with_index do |line, i|
      next unless line.include? '@'
      @y = i
      @x = line.index('@')
      @grid[@y][@x] = '.'
      break
    end
  end

  def oob?(y, x)
    y < 0 || y >= @rows || x < 0 || x >= @cols
  end

  def get(y, x)
    return nil if oob?(y, x)
    @grid[y][x]
  end

  def set(y, x, value)
    return nil if oob?(y, x)
    @grid[y][x] = value
  end

  def set_horz(y, x, value, count)
    return nil if oob?(y, x + count)
    @grid[y][x + count] = value
  end

  def to_s
    @grid[@y][@x] = '@'
    output = @grid.map(&:join).join("\n")
    @grid[@y][@x] = '.'
    output
  end

  def ahead(dir, count = 1)
    return nil if oob?(@y + (DIRS[dir][0] * count), @x + (DIRS[dir][1] * count))
    @grid[@y + (DIRS[dir][0] * count)][@x + (DIRS[dir][1] * count)]
  end

  def yxahead(y, x, dir, count = 1)
    return nil if oob?(y + (DIRS[dir][0] * count), x + (DIRS[dir][1] * count))
    @grid[y + (DIRS[dir][0] * count)][x + (DIRS[dir][1] * count)]
  end

  def pushable_box?(y, x, dir)
    here = @grid[y][x]
    return true if here == '.'
    return false if here == '#'

    xhere = x + BOX_DIR[here]

    phere = @grid[y][xhere]
    raise 'badbox' unless OPP[phere] == here

    yahead = y + DIRS[dir][0]
    return true if [@grid[yahead][x], @grid[yahead][xhere]].all? '.'

    #im double calling here in some cases but w/e its a small board
    pushable_box?(yahead, x, dir) && pushable_box?(yahead, xhere, dir)
  end

  def push_box(y, x, dir)
    here = @grid[y][x]
    xhere = x + BOX_DIR[here]
    yahead = y + DIRS[dir][0]

    if BOX.include? @grid[yahead][x]
      push_box(yahead, x, dir)
    end

    if BOX.include? @grid[yahead][xhere]
      push_box(yahead, xhere, dir)
    end

    @grid[yahead][x] = @grid[y][x]
    @grid[y][x] = '.'
    @grid[yahead][xhere] = @grid[y][xhere]
    @grid[y][xhere] = '.'
  end

  def step(dir)
    look = ahead(dir)
    if look == '.'
      @y += DIRS[dir][0]
      @x += DIRS[dir][1]
      return 1
    end

    return 0 if look == '#'

    count = 1
    if HORZ.include? dir
      while BOX.include? look
        count += 1
        look = ahead(dir, count)
        # pp "looking ahead #{count}, saw #{look}"
      end

      return 0 if look == '#'

      front = ahead(dir)
      minus = count - 1
      count *= -1 if dir == '<'
      minus *= -1 if dir == '<'

      set_horz(@y, @x, OPP[front], count)
      @grid[@y][@x + DIRS[dir][1]] = '.'

      sort = [@x + (DIRS[dir][1] * 2), @x + minus].sort
      @grid[@y][sort[0]..sort[1]] = @grid[@y][sort[0]..sort[1]].map { |char| OPP[char] }


      @x += DIRS[dir][1]
    else #VERTICAL, recurse
      return 0 unless pushable_box?(@y + DIRS[dir][0], @x, dir)

      push_box(@y + DIRS[dir][0], @x, dir)
      @y += DIRS[dir][0]
    end
  end

  def gps
    sum = 0
    @grid.each_with_index do |line, i|
      line.each_with_index do |char, j|
        sum += (i * 100) + j if char == '['
      end
    end

    sum
  end
end

board = Board.new(board_string)

puts board

pp instructions

instructions.chars.each do |dir|
  board.step(dir)
  puts dir
  # puts board
end

puts board
puts board.gps

board = Grid.new(board_string)
puts board

instructions.chars.each do |dir|
  board.step(dir)
  # puts dir
  # puts board
end

puts board

puts board.gps
