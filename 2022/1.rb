require 'net/http'

example = File.read('1.txt')

puts example

sums = []
index = 0
sums[index] = 0

example.each_line do |line|
  if line == "\n"
    index += 1
    sums[index] = 0
  else
    sums[index] += line.to_i
  end
end

puts sums.max

puts
puts sums.max(3).sum