filename = '13.txt'
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
pp busses

product = 1
busses.each do |bus|
  product *= bus.to_i if bus.to_i.positive?
end

nis = []
busses.each do |bus|
  if bus.to_i.positive?
    nis.push  product / bus.to_i
  else
    nis.push 0
  end
end

pp nis

def inverse_mod(num, mod)
  num = num % mod
  res = nil
  (0..mod).each do |step|
    k = (step * mod) + 1
    return k / num if k % num == 0
  end
  res
end

while false
  pp "num"
  num = gets.to_i
  pp "mod"
  mod = gets.to_i
  pp pp inverse_mod(num, mod)
end


zis = []
busses.each_with_index do |bus, i|
  if nis[i].positive?
    zis.push inverse_mod(nis[i], bus.to_i)
  else
    zis.push 0
  end
end


pp zis


sums = []
busses.each_with_index do |bus, i|
  if bus.to_i > 0
    sums.push ((bus.to_i - i) % bus.to_i) * nis[i] * zis[i]
  else
    sums.push 0
  end
end

pp sums
pp sums.sum % product

