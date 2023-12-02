require 'set'
example = File.open("15e.txt").readlines.map(&:chomp)

class Integer
  def million
    self * 1000000
  end
end

Coord = Struct.new(:x, :y)

coords = example.map do |line|
  ar = line.scan(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/).first.map(&:to_i)
  [Coord.new(ar[0],ar[1]), Coord.new(ar[2],ar[3])]
end

def distance(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs
end

sensors = coords.map do |pair|
  [pair.first, distance(pair.first, pair.last)]
end

pp sensors
max_distance = sensors.map(&:last).max
min_x = (coords.map(&:first).map(&:x) + coords.map(&:last).map(&:x)).min - max_distance - 1
max_x = (coords.map(&:first).map(&:x) + coords.map(&:last).map(&:x)).max + max_distance + 1

pp "min: #{min_x}, max: #{max_x}"

# withins = 0
# (min_x..max_x).each do |i|
#
#   pp i if i % 200000 == 0
#   sensors.each do |sensor|
#     if distance(Coord.new(i, 2000000), sensor.first) <= sensor.last
#       withins += 1
#       break
#     end
#   end
# end
#
#pp withins - 1 #I have no idea why. But it works. Probs cause theres a beacon there already?


@sets = Array.new(30) { Array.new }

def sets(sensor)
  coord = sensor.first
  distance = sensor.last
  size = (distance * 2) + 1
  size.times do |i|
    adjust = i - (size / 2)
    range_min = coord.x - distance + adjust.abs
    range_max = coord.x + distance - adjust.abs
    #pp "setting range #{(range_min..range_max)} at y: #{coord.y + adjust}"
    @sets[coord.y + adjust].push (range_min..range_max)
  end
end

sensors.each do |sensor|
  sets(sensor)
end


pp @sets

pp "asdf"

majors = @sets.map.with_index do |ranges, i|
  ranges.sort! {|a,b| a.min <=> b.min}
  pp ranges.to_s + i.to_s
  major = ranges.first
  ranges.each do |range|
    next if major.cover? range
    if range.min <= (major.max + 1)
      major = major.min..range.max
    else
      pp "breaky at #{i}"
      pp major
      pp range
    end
  end
  [major]
end

majors.each_with_index do |major, i|
  pp i
  pp major
end

