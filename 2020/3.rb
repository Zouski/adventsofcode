filename = '3.txt'
input = File.open(filename).readlines.map(&:chomp)

trees = 0
a, b, c, d = 0, 0, 0, 0

input.each_with_index do |row,i|
  trees += 1 if row[(i * 3) % row.length] == '#'
  a += 1 if row[i % row.length] == '#'
  b += 1 if row[(i * 5) % row.length] == '#'
  c += 1 if row[(i * 7) % row.length] == '#'
  next if i.odd?

  d += 1 if row[i / 2 % row.length] == '#'
end

pp trees
pp a * b * c * d * trees