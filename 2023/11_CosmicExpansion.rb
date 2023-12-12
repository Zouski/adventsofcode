input = File.open('11.txt').readlines.map(&:chomp)


original_map = input

chart = original_map.map(&:clone)

MIL_SIZE = 1000000 - 1

#expand chat

#rows
expanded = []
chart.map!(&:chars)

chart.each do |row|
  expanded.push row
  expanded.push row if row.count('#') == 0
end

chart = expanded.transpose

expanded = []
chart.each do |row|
  expanded.push row
  expanded.push row if row.count('#') == 0
end

expanded = expanded.transpose
# pp expanded

Point = Struct.new(:y, :x)

galaxies = []
expanded.each_with_index do |row, y|
  row.each_with_index do |val, x|
    next if val == '.'

    galaxies.push Point.new(y, x)
  end
end

sum = 0
galaxies.each_with_index do |galaxy, i|
  galaxies[i..].each do |second|
    sum += (galaxy.x - second.x).abs + (galaxy.y - second.y).abs
  end
end

# ------------ part 2
sum2 = 0
y_mils = []
x_mils = []

chart = original_map.map(&:clone)
chart.map!(&:chars)

chart.each_with_index do |row, y|
  y_mils.push y if row.count('#') == 0
end

chart.transpose.each_with_index do |row, y|
  x_mils.push y if row.count('#') == 0
end

galaxies = []
chart.each_with_index do |row, y|
  row.each_with_index do |val, x|
    next if val == '.'

    galaxies.push Point.new(y, x)
  end
end

# pp y_mils
# pp x_mils
# pp galaxies
# pp chart

galaxies.each_with_index do |galaxy, i|
  galaxies[i..].each do |second|
    sum2 += (galaxy.x - second.x).abs + (galaxy.y - second.y).abs
    exes = [galaxy.x, second.x].sort
    x_range = exes.first..exes.last
    whys = [galaxy.y, second.y].sort
    y_range = whys.first..whys.last

    x_mils.each do |x_mil|
      sum2 += MIL_SIZE if x_range.cover? x_mil
    end

    y_mils.each do |y_mil|
      sum2 += MIL_SIZE if y_range.cover? y_mil
    end
  end
end

pp sum
pp sum2
