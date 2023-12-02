filename = '1.txt'
input = File.open(filename).readlines.map(&:chomp).map(&:to_i)

pp input

pp "size: #{input.size}"
pp "first: #{input[0]}"

increases = 0

input.each_with_index do |element, index|
  next if index == 0

  increases += 1 if element > input[index-1]
end

pp increases