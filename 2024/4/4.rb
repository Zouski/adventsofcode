input = File.open('2024/4/4.txt').readlines.map(&:chomp)

class Board
  attr_accessor :board

  def initialize(input)
    @board = input
    @length = input.length
    @ops = {"M" => "S",
            "S" => "M"}
    @poss = %w[M S]
  end

  def check(y, x)
    return nil if y < 0 || y >= @length || x < 0 || x >= @length

    @board[y][x]
  end

  def find(y, x)
    count = 0
    9.times do |i|
      next if i == 4
      y1 = (y - 1) + (i / 3)
      x1 = (x - 1) + (i % 3)
      if check(y1, x1) == 'M'
        y2 = y1 - (y - y1)
        x2 = x1 - (x - x1)
        if check(y2, x2) == 'A'
          y3 = y2 - (y - y1)
          x3 = x2 - (x - x1)
          if check(y3,x3) == 'S'
            count += 1
          end
        end
      end
    end
    count
  end


  def x(y, x)
    count = 0
    if @poss.include? check(y-1, x-1)
      count += 1 if check(y+1, x+1) == @ops[check(y-1, x-1)]
    end
    if @poss.include? check(y-1, x+1)
      count += 1 if check(y+1, x-1) == @ops[check(y-1, x+1)]
    end
    if count == 2
      1
    else
      0
    end
  end
end

b = Board.new(input)

count = 0
xc = 0
b.board.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == 'X'
      count += b.find(y, x)
    end
    if char == 'A'
      xc += b.x(y,x)
    end
  end
end

pp count
pp xc