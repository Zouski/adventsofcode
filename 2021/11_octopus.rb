filename = '11.txt'
input = File.open(filename).readlines.map(&:chomp)

@grid =  input.map { |i| i.split('').map(&:to_i) }

pp @grid

def flash(y, x)
  9.times do |i|
    next if i == 4

    x2 = x + (i / 3) - 1
    y2 = y + (i % 3) - 1

    next if x2.negative? || x2 > 9 || y2.negative? || y2 > 9

    @grid[y2][x2] += 1
    flash(y2, x2) if @grid[y2][x2] == 10
  end
end

def step
  flashes = 0
  @grid.each_with_index do |row, y|
    row.length.times do |x|
      @grid[y][x] += 1
      flash(y, x) if @grid[y][x] == 10
    end
  end

  @grid.each_with_index do |row, y|
    row.each_with_index do |i, x|
      if i > 9
        @grid[y][x] = 0
        flashes += 1
      end
    end
  end

  flashes
end

flashes = 0
100.times do
  flashes += step
end

pp flashes

1.step do |i|
  step
  if @grid.flatten.all? 0
    pp i + 100
    break
  end
end
