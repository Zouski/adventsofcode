filename = '11.txt'
input = File.open(filename).readlines.map(&:chomp)
input.insert(0, '.' * input.length)
input.push('.' * (input.length - 1))
input.length.times do |i|
  input[i].insert(0,'.')
  input[i] += '.'
end
input = input.map do |row|
  row.split('')
end

pp input

@lobby = input.map(&:clone)
@last = @lobby.map(&:clone)

#x: 1, y: 1

x = 5
y = 5
9.times do |i|
  next if i == 4
  y1 = (y - 1) + (i / 3)
  x1 = (x - 1) + (i % 3)
  pp "#{x1}, #{y1}"
end

x = 5
y = 5
9.times do |i|
  next if i == 4
  x2 = (i / 3) - 1
  y2 = (i % 3) - 1
  pp "#{x2}, #{y2}"
end

def display(board)
  board.each do |row|
    puts row.join.to_s
  end
end

def check_surroundings(x, y)
  occupied = 0
  9.times do |i|
    next if i == 4

    occupied += 1 if @last[(y - 1) + (i / 3)][(x - 1) + (i % 3)] == '#'
  end
  occupied
end

def check_surroundings_better(x, y)
  occupied = 0

  9.times do |i|
    next if i == 4


    xd = (i / 3) - 1
    yd = (i % 3) - 1
    xp = x + xd
    yp = y + yd
    while yp.positive? && yp < @lobby.length && xp.positive? && xp < @lobby.length
      if @last[yp][xp] == '#'
        occupied += 1
        break
      elsif @last[yp][xp] == 'L'
        break
      end

      xp += xd
      yp += yd
    end
  end
  occupied
end

def take_your_seats
  @last.each_with_index do |row, y|
    row.each_with_index do |seat, x|
      next unless %w[L #].include? seat

      if seat == 'L'
        @lobby[y][x] = '#' if check_surroundings(x, y) == 0
      else
        @lobby[y][x] = 'L' if check_surroundings(x, y) >= 4
      end
    end
  end
end

def take_your_seats_harder
  @last.each_with_index do |row, y|
    row.each_with_index do |seat, x|
      next unless %w[L #].include? seat

      if seat == 'L'
        @lobby[y][x] = '#' if check_surroundings_better(x, y).zero?
      elsif check_surroundings_better(x, y) >= 5
        @lobby[y][x] = 'L'
      end
    end
  end
end

@lobby = input.map(&:clone)
@last = @lobby.map(&:clone)

count = 0
take_your_seats
display @lobby
while @last != @lobby
  pp count
  count += 1
  @last = @lobby.map(&:clone)
  take_your_seats
end


display(@lobby)
pp @lobby.flatten.count('#')

@lobby = input.map(&:clone)
@last = @lobby.map(&:clone)

count = 0
take_your_seats_harder
display @lobby
while @last != @lobby
  #pp count
  count += 1
  @last = @lobby.map(&:clone)
  take_your_seats_harder
  #display(@lobby)
end


display(@lobby)
pp @lobby.flatten.count('#')

















