filename = '13e.txt'
input = File.open(filename).readlines.map(&:chomp)

arrive = input[0].to_i
busses = input[1].split ','
busses.delete 'x'
busses = busses.map(&:to_i)

waits = []
busses.each_with_index do |bus, i|
  next_stop = ((arrive / bus) + 1) * bus
  #pp "bus #{bus} arrive #{arrive} next stop #{next_stop} diff #{next_stop - arrive}"
  waits[i] = next_stop - arrive
end

min_index = waits.each_with_index.min
pp min_index[0] * busses[min_index[1]]


busses = input[1].split(',')
busses = "17,x,13,19".split(',')
pp busses


increment = busses.first.to_i
t0 = increment

busses[1..-1].each_with_index do |bus, i|
  next if bus == 'x'

  time = t0
  bus = bus.to_i
  while time % bus != bus - 1
    time += increment
  end
  pp time

  t0 = time

  # now find next
  time += increment
  while time % bus != bus - 1
    time += increment
  end

  increment = time - t0
  pp time
end


a = 7
b = 13

input = File.open(filename).readlines.map(&:chomp)
pp input


busses = input.last.split(',')
pp busses

a = 7
b = 13

