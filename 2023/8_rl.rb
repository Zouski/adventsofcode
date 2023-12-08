input = File.open('8.txt').readlines.map(&:chomp)

# pp input
commence = Time.now
directions = input.first

Node = Struct.new(:name, :left, :right)


nodes = input.drop(2).map do |node|
  node = node.split
  Node.new(node.first, node[2][1..3], node[3][0..2])
end

nodes.sort_by! { |node| node.name }

current = nodes.first
i = 0
length = directions.length

while current.name != "ZZZ"
  current = if directions[i % length] == 'L'
              nodes.bsearch { |node| node.name >= current.left }
            else
              nodes.bsearch { |node| node.name >= current.right }
            end
  i += 1
end

starts = nodes.select{ |node| node.name[2] == "A" }

offsets = []
starts.each do |start|
  current = nodes.bsearch { |node| node.name >= start.name }
  i = 0

  while current.name[2] != "Z"
    current = if directions[i % length] == 'L'
                nodes.bsearch { |node| node.name >= current.left }
              else
                nodes.bsearch { |node| node.name >= current.right }
              end
    i += 1
  end
  offsets.push i
end

#what, the loops are the same as the offsets. well thats a coincidence??????????????? ok that makes things very easy

part2 = offsets.reduce(1, :lcm)

fin = Time.now
pp fin - commence
pp i
pp part2


