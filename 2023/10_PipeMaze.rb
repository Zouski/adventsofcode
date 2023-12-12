input = File.open('10.txt').readlines.map(&:chomp)
input.each do |row|
  row.gsub!('7', '┐')
end

# set left or right hand rule manually, cant be assed

class Board
  attr_accessor :board

  def initialize(board)
    if board.first.class == String
      @board = board.map(&:chars)
    else
      @board = board
    end

    @board = @board.map do |row|
      ['.'] + row + ['.']
    end

    @board.insert(0, ['.'] * (@board.first.length))
    @board.push ['.'] * (@board.first.length)
  end

  def display
    @board.each_with_index do |row, y|
      puts '%04d' % y + ' ) ' + "#{row.join}"
    end
  end

  def get(y, x)
    return '.' if y.negative? || y >= @board.length
    return '.' if x.negative? || x >= @board[y].length

    @board[y][x]
  end

  def set(y, x, val)
    # raise 'y' if y.negative? || y >= @board.length
    # raise 'x' if x.negative? || x >= @board[y].length

    # pp "setting #{val}"
    @board[y][x] = val
  end
end

board = Board.new(input)

Point = Struct.new(:y, :x)
s_point = nil

board.board.each_with_index do |row, y|
  x = row.index('S')
  unless x.nil?
    s_point = Point.new(y, x)
  end
end

start = s_point.clone

first_step =  if '|F┐'.include? board.get(start.y - 1, start.x)
                came_from = :u
                Point.new(start.y - 1, start.x)
              elsif '|JL'.include? board.get(start.y + 1, start.x)
                came_from = :d
                Point.new(start.y + 1, start.x)
              else
                came_from = :l
                Point.new(start.y, start.x - 1)
              end

step = first_step.clone
first_came_from = came_from
# pp s_point

step_row = [0] * input.length
steps = []
input.length.times do
  steps.push step_row.clone
end
steps = Board.new(steps)

steps.set(start.y, start.x, 1)
steps.set(step.y, step.x, 2)

directions = {
  '|' => [:u, :d],
  '-' => [:l, :r],
  'F' => [:d, :r],
  'J' => [:u, :l],
  'L' => [:u, :r],
  '┐' => [:d, :l],
  'S' => [:l, :r, :u, :d]
}

opposites = {
  :r => :l,
  :l => :r,
  :u => :d,
  :d => :u
}

@additions = {
  r: [0, 1],
  l: [0, -1],
  u: [-1, 0],
  d: [1, 0]
}
# we have start and step. start is last, step is next

# board.display
step_count = 2
until board.get(step.y, step.x) == 'S'
  step_count += 1
  # pp "at #{board.get(step.y, step.x)}, at y#{step.y} x#{step.x} came from #{came_from}"
  direction = (directions[board.get(step.y, step.x)] - [opposites[came_from]]).first
  # pp "heading #{direction}"
  came_from = direction

  steps.set(step.y, step.x, step_count)
  step.y += @additions[direction].first
  step.x += @additions[direction].last
end

max = 0
# steps.display
steps.board = steps.board.map do |row|
  row.map do |val|
    val = 0 if val == '.'
    val
  end
end

# steps.display
steps.board.each do |step_row|
  max = [step_row.max, max].max
end

pp (max - 1) / 2
#ok find Start - done
# take first step (record came_from) done
# subract came from from possible dirs at current

left_hand_rule = {
  d: :r,
  r: :u,
  u: :l,
  l: :d
}

right_hand_rule = {
  d: :l,
  r: :d,
  u: :r,
  l: :u
}

def set_guts(board, point, direction)
  point.y += @additions[direction].first
  point.x += @additions[direction].last

  # board.display
  # pp board.get(point.y, point.x)
  until board.get(point.y, point.x).positive?
    board.set(point.y, point.x, -1)
    point.y += @additions[direction].first
    point.x += @additions[direction].last
  end
end

# travel path again - but this time call set_guts on internal directions

# pp s_point

step = first_step
came_from = first_came_from

# pp steps

# pp board
until board.get(step.y, step.x) == 'S'
  # pp "at #{board.get(step.y, step.x)}, at y#{step.y} x#{step.x} came from #{came_from}"
  direction = (directions[board.get(step.y, step.x)] - [opposites[came_from]]).first
  # pp"heading #{direction}"

  # set left or right manually, cant be assed
  set_guts(steps, step.clone, right_hand_rule[direction])
  step.y += @additions[direction].first
  step.x += @additions[direction].last
  set_guts(steps, step.clone, right_hand_rule[direction])


  came_from = direction
end

# pp steps

count = 0
steps.board.each do |row|
  count += row.count -1
end

pp count