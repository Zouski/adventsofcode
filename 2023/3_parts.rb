@data = File.open('3.txt').readlines.map(&:chomp)

data = @data

@gears = {}

def symbol_around?(i, x, length, number)
  length += 1 if (x + length + 1) < @data.first.length
  x -= 1 if x > 0

  start = i > 0 ? i - 1 : i
  fin = i + 1 < @data.length ? i + 1 : i

  @data[start..fin].each_with_index do |line, mid|
    sample = line[x..x + length]
    next if sample.gsub(/[\d.]/, '').empty?

    if sample.index '*'
      @gears[start + mid] ||= {}
      @gears[start + mid][x + sample.index('*')] ||= []
      @gears[start + mid][x + sample.index('*')].push number
    end

    return true
  end

  false
end

sum = 0
data.each_with_index do |line, i|
  numbers = line.scan /\d+/
  pp numbers unless numbers.uniq
  numbers.each do |number|
    x = line.index(number)
    sum += number.to_i if symbol_around?(i, x, number.length, number.to_i)
    line[x..x + number.length - 1] = '0' * number.length
  end
end

pp sum


prosum = 0
@gears.each do |x|
  x.last.each do |numbers|
    prosum += numbers.last.first * numbers.last.last if numbers.last.length == 2
  end
end

pp prosum
