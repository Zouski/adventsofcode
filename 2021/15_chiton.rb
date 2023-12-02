filename = '15e.txt'
input = File.open(filename).readlines.map(&:chomp)

@map = input.map { |row| row.split('').map(&:to_i) }

@path = @map.map { |row| row.dup }
@path[0][0] = 0
pp @map
@size = @map.length

max = @map.flatten.sum
@minpaths = Array.new(@size) { Array.new(@size, max) }
@minpaths[0][0] = 0

def calculate_easy_min_path
  rightdown = @map.first.sum + @map.transpose.last.sum - @map.first.first - @map.first.last
  downright = @map.transpose.first.sum + @map.last.sum - @map.first.first - @map.last.first

  [rightdown, downright].min
end

@minpath = calculate_easy_min_path

pp @minpath

def leave_cell(y, x, score)
  @minpaths[y][x] = score
  pp @path

  if (y == @size - 2 && x == @size - 1) || (y == @size - 1 && x == @size - 2)
    newscore = score + @map[-1][-1]
    @minpath = newscore if newscore < @minpath
    pp "y #{y} x #{x} reached the end with #{newscore}"
    return
  end

  down = right = up = left = false

  if y < @size - 1 && @path[y+1][x] != 0
    @path[y+1][x] = 0
    if score + @map[y+1][x] < @minpaths[y+1][x]
      down = true
    end
  end

  if x < @size - 1 && @path[y][x+1] != 0
    @path[y][x+1] = 0
    if score + @map[y][x+1] < @minpaths[y][x+1]
      right = true
    end
  end

  if y != 0 && @path[y-1][x] != 0
    @path[y-1][x] = 0
    if score + @map[y-1][x] < @minpaths[y-1][x]
      up = true
    end
  end

  if x != 0 && @path[y][x-1] != 0
    @path[y][x-1] = 0
    if score + @map[y][x-1] < @minpaths[y][x-1]
      left = true
    end
  end

  if down
    score += @map[y+1][x]
    pp "y #{y} x #{x} going down"
    leave_cell(y+1, x, score)
    pp "y #{y} x #{x} got back"
  end

  if right
    score += @map[y][x+1]
    pp "y #{y} x #{x} going right"
    leave_cell(y, x+1, score)
    pp "y #{y} x #{x} got back"
  end

  if up
    score += @map[y-1][x]
    pp "y #{y} x #{x} going up"
    leave_cell(y-1, x, score)
    pp "y #{y} x #{x} got back"
  end

  if left
    score += @map[y][x-1]
    pp "y #{y} x #{x} going left"
    leave_cell(y, x-1, score)
    pp "y #{y} x #{x} got back"
  end

  @path[y][x-1] = @map[y][x-1] if right
  @path[y+1][x] = @map[y+1][x] if down
  @path[y-1][x] = @map[y-1][x] if up
  @path[y][x-1] = @map[y][x-1] if left
  pp "y #{y} x #{x} function ended"
end

pp "ok, trying"
pp "size is #{@size}"
leave_cell(0,0,0)
pp "ended"
pp @minpath




