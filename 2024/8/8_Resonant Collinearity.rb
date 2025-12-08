input = File.open('2024/8/8.txt').readlines.map(&:chomp)

pp input

Node = Struct.new(:y, :x) do
  def +(other)
    Node.new(self.y + other.y, self.x + other.x)
  end

  def -(other)
    Node.new(self.y - other.y, self.x - other.x)
  end
end

class Board
  attr_accessor :size

  def initialize(input)
    @size = input.length
  end

  def oob?(node)
    node.y < 0 || node.y >= @size || node.x < 0 || node.x >= @size
  end
end

board = Board.new(input)

map = Hash.new { |h, k| h[k] = [] }
input.each_with_index do |line, i|
  line.chars.each_with_index do |char, j|
    next if char == '.'
    map[char].append Node.new(i,j)
  end
end

antis = Hash.new { |h, k| h[k] = [] }
map.each do |f, nodes|
  nodes.combination(2).each do |combo|
    difference = Node.new(combo.first.y - combo.last.y, combo.first.x - combo.last.x)

    first = combo.first + difference
    second = combo.last - difference
    antis[first].append f unless board.oob?(first)
    antis[second].append f unless board.oob?(second)
  end
end

antis.each do |k, v|
  #puts "#{k}, #{v}"
end

puts antis.keys.length


bantis = Hash.new { |h, k| h[k] = [] }
map.each do |f, nodes|
  nodes.combination(2).each do |combo|
    difference = Node.new(combo.first.y - combo.last.y, combo.first.x - combo.last.x)

    first = combo.first
    until board.oob? first
      bantis[first].append f
      first = first + difference
    end
    first = combo.last
    until board.oob? first
      bantis[first].append f
      first = first - difference
    end
  end
end

puts bantis.keys.length