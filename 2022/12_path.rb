example = File.read('12.txt')

@board = example.split.map do |a|
  a.split('')
end

# pp @board
MAX_X = @board.first.size - 1
MAX_Y = @board.size - 1

start_y = @board.find_index {|row| row.include? "S"}
end_y = @board.find_index {|row| row.include? "E"}


start_x = @board[start_y].index "S"
end_x = @board[end_y].index "E"

@board[start_y][start_x] = 'a'
@board[end_y][end_x] = 'z'

@path = Array.new(@board.size) { Array.new(@board.first.size, nil)}
# pp @path

@path2 = Array.new(@board.size) { Array.new(@board.first.size, nil)}

def can_step?(x1, y1, x2, y2)
  @board[y1][x1].ord - @board[y2][x2].ord >= -1
end

def can_step_down?(x1, y1, x2, y2)
  @board[y1][x1].ord - @board[y2][x2].ord <= 1
end


def bfs(x, y, steps)
  local_score = @path[y][x]
  if local_score.nil? || local_score > steps
    @path[y][x] = steps

    bfs(x + 1, y, steps + 1) if x < MAX_X && can_step?(x, y, x + 1, y)

    bfs(x, y - 1, steps + 1) if y > 0 && can_step?(x, y, x, y - 1)

    bfs(x, y + 1, steps + 1) if y < MAX_Y && can_step?(x, y, x, y + 1)

    bfs(x - 1, y, steps + 1) if x > 0 && can_step?(x, y, x - 1, y)
  end
end

bfs(start_x, start_y, 0)
# pp @path
pp @path[end_y][end_x]

def bfs2(x, y, steps)
  local_score = @path2[y][x]
  if local_score.nil? || local_score > steps
    @path2[y][x] = steps

    bfs2(x + 1, y, steps + 1) if x < MAX_X && can_step_down?(x, y, x + 1, y)

    bfs2(x, y - 1, steps + 1) if y > 0 && can_step_down?(x, y, x, y - 1)

    bfs2(x, y + 1, steps + 1) if y < MAX_Y && can_step_down?(x, y, x, y + 1)

    bfs2(x - 1, y, steps + 1) if x > 0 && can_step_down?(x, y, x - 1, y)
  end
end

bfs2(end_x, end_y, 0)
# pp @path2

Coord = Struct.new(:x, :y)
as = []
@board.each_with_index do |row, y|
  row.each_with_index do |char, x|
    as.push @path2[y][x] if char == 'a' && !@path2[y][x].nil?
  end
end

pp as.min