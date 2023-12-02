filename = '7.txt'
input = File.open(filename).readlines.map(&:chomp).first.split(',').map(&:to_i).sort

pp @crabs = input

pp index = input.length / 2 - 1
low_gas = index


def get_gas(position)
  gas = 0
  @crabs.each { |crab| gas += (position - crab).abs }
  gas
end

def triangle(number)
  return number if number < 2

  number + triangle(number - 1)
end

def get_triangle_gas(position)
  gas = 0
  @crabs.each { |crab| gas += triangle((position - crab).abs) }
  gas
end


#get direction

current = get_gas @crabs[index]
pp "current", current
pp "next", get_gas(@crabs[index] - 1)
direction = current > get_gas(@crabs[index] - 1) ? -1 : 1
new = 0
index.times do |i|
  pp i
  new = get_gas(@crabs[index] + (i * direction))
  break if new > current

  current = new
end

pp new, current

min = get_triangle_gas(@crabs.first)
(@crabs.min..@crabs.max).each do |i|
  after = get_triangle_gas(i)
  pp "position #{i}, gas #{after}"
  min = after if after < min
end

pp min