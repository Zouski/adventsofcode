filename = '9.txt'
input = File.open(filename).readlines.map(&:chomp).map { |i| i.split('').map(&:to_i) }

@map = input.dup

score = 0

@map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    here = @map[y][x]
    if y.positive?
      next if @map[y - 1][x] <= here
    end

    if y != @map.length - 1
      next if @map[y + 1][x] <= here
    end

    if x.positive?
      next if @map[y][x - 1] <= here
    end

    if x != row.length - 1
      next if @map[y][x + 1] <= here
    end

    score += cell + 1
  end
end

pp score

def check_orthogonal(y, x)
  return 0 if @map[y][x] == 9

  @map[y][x] = 9
  sum = 1

  sum += check_orthogonal(y - 1, x) if y.positive?
  sum += check_orthogonal(y + 1, x) if y != @map.length - 1
  sum += check_orthogonal(y, x - 1) if x.positive?
  sum += check_orthogonal(y, x + 1) if x != @map.first.length - 1

  sum
end

basins = []
@map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if cell == 9

    basins.push check_orthogonal(y, x)
  end
end

final = basins.max(3)
pp final[0] * final[1] * final[2]



