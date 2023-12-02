# frozen_string_literal: true
example = File.read('5.txt')

length = 0
height = 0
example.each_line.with_index do |line, index|
  next unless line.include? '1'

  length = line.split.last.to_i
  height = index
  break
end

puts length
puts height

boxes = example.split("\n").slice(0..height - 1)
instructions = example.split("\n").slice(height + 2..-1)

stacks = Array.new(length) { Array.new }
boxes.reverse.each do |row|
  length.times do |i|
    char = row[1 + (i * 4)]
    next if char.nil?
    stacks[i].push char unless char == ' '
  end
end

pp stacks
stacks2 = stacks.map(&:clone)

instructions.each do |instruction|
  order = instruction.scan(/move (\d+) from (\d) to (\d)/).first.map!(&:to_i)
  order.first.times do
    stacks[order[2]-1].push(stacks[order[1]-1].pop)
  end
end

pp stacks

string = ""
stacks.each do |stack|
  string += stack.last unless stack.last.nil?
end
pp string

instructions.each do |instruction|
  order = instruction.scan(/move (\d+) from (\d) to (\d)/).first.map!(&:to_i)
  stacks2[order[2]-1] = stacks2[order[2]-1] + stacks2[order[1]-1].pop(order[0])
end

string = ""
stacks2.each do |stack|
  string += stack.last unless stack.last.nil?
end
pp string