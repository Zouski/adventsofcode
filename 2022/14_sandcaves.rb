file = File.open("14.txt")

paths = []
until file.eof?
  paths.push file.readline.chomp.split(" -> ").map {|p| p.split(',').map(&:to_i)}
end

#pp paths


SIZE_Y = 170
SIZE_X = 700

$cave = Array.new(SIZE_Y) { Array.new(SIZE_X, ',') }
#$cave[0][500] = '+'

class Coord
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def can_fall
    return 0 if $cave[@y + 1][@x] == ','
    return -1 if $cave[@y + 1][@x - 1] == ','
    return 1 if $cave[@y + 1][@x + 1] == ','

    nil
  end
end

class Coord2
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def can_fall
    return 0 if $cave2[@y + 1][@x] == ','
    return -1 if $cave2[@y + 1][@x - 1] == ','
    return 1 if $cave2[@y + 1][@x + 1] == ','

    nil
  end
end





def display
  $cave.each_with_index do |line,i|
    s = ''
    line.each_with_index do |space, x|
      s += space if x > 475
    end
    puts s + i.to_s
  end
end

def display2
  $cave2.each_with_index do |line,i|
    s = ''
    line.each_with_index do |space, x|
      s += space
    end
    puts s + i.to_s
  end
end



paths.each do |path|
  prev = path.first
  $cave[path.first.last][path.first.first] = '#'
  path.each_with_index do |coord, i|
    next if i.zero?

    $cave[coord.last][coord.first] = '#'
    if coord.first == prev.first #y move
      #pp "y move: #{prev}, #{coord}"
      distance = coord.last - prev.last

      distance.abs.times do |j|
        offset = prev.last + (distance.positive? ? j : -j)
        #pp "setting x:#{prev.first} y:#{offset}"
        $cave[offset][prev.first] = '#'
      end
    else #x move
      #pp "x move: #{prev}, #{coord}"
      distance = coord.first - prev.first

      distance.abs.times do |j|
        offset = prev.first + (distance.positive? ? j : -j)
        #pp "setting x:#{offset} y:#{prev.last}"
        $cave[prev.last][offset] = '#'
      end
    end
    prev = coord
  end
end

$cave2 = $cave.map(&:dup)
$cave2[166] = Array.new(SIZE_X, '#')


start = Coord.new(0, 500)
chain = [start.dup]
sands = 0
loop do

  pp "looking at #{chain.last.x} #{chain.last.y}"
  until chain.last.can_fall.nil?
    start.x += start.can_fall
    start.y += 1

    chain.push start.dup
    pp "fell to #{start.x} #{start.y}"
    break if start.y >= $cave.size - 1
  end
  break if start.y >= $cave.size - 1

  if $cave[start.y][start.x] == ','
    $cave[start.y][start.x] = 'o'
    sands += 1
  end

  chain.pop
  start = chain.last


end

display


pp sands

count = 0
$cave.each do |line|
  count += line.count 'o'
end
pp count
#rest, next start is prev

display2


start = Coord2.new(0, 500)
chain = [start.dup]
sands = 0
loop do

  #pp "looking at #{chain.last.x} #{chain.last.y}"

  if chain.empty? && $cave2[0][500] != 'o'
    start = Coord2.new(-1, 500)
    chain = [start.dup]
  end

  break if chain.empty?

  until chain.last.can_fall.nil?
    start.x += start.can_fall
    start.y += 1

    chain.push start.dup
    #pp "fell to #{start.x} #{start.y}"
    break if start.y >= $cave2.size - 1
  end
  break if start.y >= $cave2.size - 1

  if $cave2[start.y][start.x] == ','
    $cave2[start.y][start.x] = 'o'
    sands += 1
    break if start.y == 0 && start.x == 500
  end

  chain.pop
  start = chain.last


end




display2
pp sands
