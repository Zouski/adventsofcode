input = File.open('5e.txt').readlines.map(&:chomp)

class Range
  def split(pivot)
    [(self.begin..pivot), (pivot + 1..self.end)]
  end
end

def sort_ranges(ranges)
  ranges.sort_by(&:begin)
end

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

seed_ranges = []
until seeds.empty?
  pair = seeds.pop 2
  seed_ranges.push((pair.first..pair.last + pair.first - 1))
end

pp seed_ranges = sort_ranges(seed_ranges)
sorted_conversions = conversions.map { |hash| hash.sort_by { |range| range.first.first }.to_h }
pp sorted_conversions

# Identify overlaps
# remove overlaps to translate
# translate overlaps into translated
# passthrough anything left into translated
# lets assume that per the example data, conversions have no gaps between first.begin and last.end
#



def translate_layer(seed_ranges, conversions)
  translated_ranges = []
  
  if conversions.first.first.begin > seed_ranges.first.begin
    split = seed_ranges.first.split(conversions.first.first.begin)
    translated_ranges.push split.first
    seed_ranges = split.last + seed_ranges.drop(1)
  end

  if conversions.last.first.end > seed_ranges.last.begin
    split = seed_ranges.first.split(conversions.first.first.begin)
    translated_ranges.push split.first
    seed_ranges = split.last + seed_ranges.drop(1)
  end

  # under and over hang dealt with, now to convert over block
  conversions.each do |c_range, offset|
    pp c_range
    seed_ranges.each do |seed_range|
      break if seed_range.begin > c_range.end

      if seed_range.end <= c_range.end
        translated_ranges.push(seed_range.begin + offset..seed_range.end + offset)
      end
    end
  end

  pp 'end'
end

translate_layer(seed_ranges, sorted_conversions.first)


