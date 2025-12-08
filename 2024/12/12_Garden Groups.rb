input = File.open('2024/12/12.txt').readlines.map(&:chomp)
original = input.map(&:dup)
@board = input.map(&:chars)
# pp @board

@size = @board.length

DIRECTIONS = [
  [-1, 0],
  [0, -1],
  [1, 0],
  [0, 1]
]

def oob?(y ,x)
  y < 0 || y >= @size || x < 0 || x >= @size
end

def step(y, x, g)
  area = 1
  borders = 0
  sides = 0

  @board[y][x] = g.downcase

  DIRECTIONS.each_with_index do |direction, i|
    y1 = y + direction[0]
    x1 = x + direction[1]

    j = i - 1
    j = 3 if j == -1
    left = DIRECTIONS[j]
    yl = y + left[0]
    xl = x + left[1]
    yl2 = yl + direction[0]
    xl2 = xl + direction[1]

    k = i + 1
    k = 0 if k == 4
    right = DIRECTIONS[k]
    yr = y + right[0]
    xr = x + right[1]
    yr2 = yr + direction[0]
    xr2 = xr + direction[1]

    if oob?(y1, x1)
      borders += 1
      sides += 1 if oob?(yl, xl) || ![g, g.downcase].include?(@board[yl][xl])
      sides += 1 if !oob?(yl2, xl2) && [g, g.downcase].include?(@board[yl2][xl2]) && [g, g.downcase].include?(@board[yl][xl])
      sides += 1 if oob?(yr, xr) || ![g, g.downcase].include?(@board[yr][xr])
      sides += 1 if !oob?(yr2, xr2) && [g, g.downcase].include?(@board[yr2][xr2]) && [g, g.downcase].include?(@board[yr][xr])
      next
    elsif @board[y1][x1] == g.downcase
      next
    elsif @board[y1][x1] == g
      result = step(y1, x1, g)
      area += result[0]
      borders += result[1]
      sides += result[2]
      next
    else
      borders += 1
      sides += 1 if oob?(yl, xl) || ![g, g.downcase].include?(@board[yl][xl])
      sides += 1 if !oob?(yl2, xl2) && [g, g.downcase].include?(@board[yl2][xl2]) && [g, g.downcase].include?(@board[yl][xl])
      sides += 1 if oob?(yr, xr) || ![g, g.downcase].include?(@board[yr][xr])
      sides += 1 if !oob?(yr2, xr2) && [g, g.downcase].include?(@board[yr2][xr2]) && [g, g.downcase].include?(@board[yr][xr])
      next
    end
  end
  [area, borders, sides]
end

regions = []
@board.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char.upcase == char
      #new region
      region = step(y, x, char)
      region[2] = region[2] / 2
      regions << region.append(char)
    end
  end
end

pp regions
total = 0
side_total = 0
priceones = []
pricetwos = []
regions.each do |region|
  t = region[0] * region[1]
  u = region[0] * region[2]
  total += t
  side_total += u
  priceones << [region[3], t]
  pricetwos << [region[3], u]
end

# pp priceones
pp total

pp pricetwos
pp side_total



