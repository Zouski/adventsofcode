input = File.open('2024/11/11.txt').readlines.map(&:chomp)
input = input.first.split(' ').map(&:to_i)
pp input

def step(set)
  new = []

  set.each do |x|
    if x == 0
      new << 1
    elsif x.to_s.length % 2 == 0
      s = x.to_s
      new << s[0..s.length/2 - 1].to_i
      new << s[s.length/2..].to_i
    else
      new << x * 2024
    end
  end
  new
end

part_one = input.dup
25.times do |i|
  part_one = step(part_one)
end

pp part_one.length

##part two
stone_map = Hash.new(0)
input.each { |stone| stone_map[stone] += 1 }

75.times do
  new_map = Hash.new(0)

  stone_map.each do |stone, n|
    if stone == 0
      new_map[1] += n
    elsif stone.digits.size.even?
      s = stone.to_s
      new_map[s[0...s.length/2].to_i] += n
      new_map[s[s.length/2..].to_i] += n
    else
      new_map[stone * 2024] += n
    end
  end

  stone_map = new_map
end

pp stone_map.values.sum








