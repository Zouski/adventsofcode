input = File.open('5.txt').readlines.map(&:chomp)

# pp input

# Each line within a map contains three numbers: the destination range start, the source range start, and the range length.

seeds = input.first.split(':').last.split.map(&:to_i)
input = input.drop 3

conversions = [{}]
num = 0
input.each do |line|
  next if line.empty?

  if line.include? ':'
    num += 1
    conversions.push({})
    next
  end

  dest, source, length = line.split.map(&:to_i)
  conversions[num][(source..(source + length - 1))] = source - dest
end

# pp conversions

locations = seeds.map do |seed|
  7.times do |i|
    conversions[i].each do |conversion|
      found = false
      if conversion.first.cover? seed
        # pp "level #{i}: converting seed #{seed} to #{seed - conversion.last} in range #{conversion.first}"
        seed -= conversion.last
        break
      end
    end
  end
  seed
end

pp locations.min

t_start = Time.now
seed_ranges = []
until seeds.empty?
  pair = seeds.pop 2
  seed_ranges.push((pair.first..pair.last + pair.first - 1))
end

sorted_conversions = conversions.map { |hash| hash.sort_by { |range| range.first.first }.to_h }
# pp sorted_conversions

# make list of points and their types, go through that
# the list should have:
#   the number along the line, the index
#   the type, :seed or :con
#   and if :con, the offset

Point = Struct.new(:index, :type, :offset) do
  def initialize(index, type, offset = nil)
    super(index, type, offset)
  end
end

def sort_points(seed_ranges, conversions)
  points = []

  seed_ranges.each do |range|
    points.push Point.new(range.begin, :seed)
    points.push Point.new(range.end, :seed)
  end

  conversions.each do |conversion|
    range = conversion.first
    points.push Point.new(range.begin, :con, conversion.last)
    points.push Point.new(range.end, :con, conversion.last)
  end

  points.sort_by(&:index)
end


7.times do |layer|
  points = sort_points(seed_ranges, sorted_conversions[layer])
  # pp points

  in_seed_range = false
  in_con_range = nil
  translated_seeds = []
  last_point = -1

  points.each do |point|
    translated_seeds.push(last_point - in_con_range.to_i..point.index - in_con_range.to_i) if in_seed_range
    if point.type == :seed
      in_seed_range = !in_seed_range
    else
      in_con_range = in_con_range.nil? ? point.offset : nil
    end

    last_point = point.index
  end

  # pp translated_seeds
  seed_ranges = translated_seeds
end

t_end = Time.now
# runs in about 0.0051 seconds

pp t_end - t_start
pp seed_ranges.first.begin

