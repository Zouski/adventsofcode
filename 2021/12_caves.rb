test_input = "start-A
start-b
A-c
A-b
b-d
A-end
b-end".lines.map(&:chomp)

test_input2 = "fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW".lines.map(&:chomp)

real_input = "start-YA
ps-yq
zt-mu
JS-yi
yq-VJ
QT-ps
start-yq
YA-yi
start-nf
nf-YA
nf-JS
JS-ez
yq-JS
ps-JS
ps-yi
yq-nf
QT-yi
end-QT
nf-yi
zt-QT
end-ez
yq-YA
end-JS".lines.map(&:chomp)


class Node
  attr_reader :value
  attr_reader :adjacent

  def initialize(value)
    @value = value
    @adjacent = []
  end

  def add_edge(adj)
    @adjacent.push adj
  end

  def to_s
    edges = @adjacent.map(&:value)
    "#{@value}: #{edges}"
  end

  def small?
    @value.downcase == @value
  end
end

class Graph

  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.value] ||= node
  end

  def add_edge(node1v, node2v)
    @nodes[node1v].add_edge(@nodes[node2v])
    @nodes[node2v].add_edge(@nodes[node1v])
  end

  def to_s
    @nodes.each_value.map(&:to_s)
  end
end

caves = Graph.new
input = real_input
input.each do |line|
  line = line.split '-'
  caves.add_node(Node.new(line.first))
  caves.add_node(Node.new(line.last))

  caves.add_edge(line.first, line.last)
end

@paths = []
#start at start, for each node pass it a path that contains [start]
# then at each node, for each node pass it [start,self], dont explore start or included small caves
# if a node and its path reaches end, add it to paths

pp caves.nodes['start'].to_s


path = ['start']
def explore_cave(node, path)
  # pp "exploring #{node.value} with path #{path}"
  # pp node.adjacent.map(&:to_s)
  node.adjacent.each do |edge|
    next if edge.small? && path.include?(edge.value)

    new_path = path.dup
    new_path.push edge.value
    if edge.value == 'end'
      # pp "End reached, pushing #{path}"
      @paths.push new_path
    end

    # pp "looking at edge #{edge.value}"
    explore_cave(edge, new_path)
  end
end

def explore_cave_better(node, path)
  # pp "exploring #{node.value} with path #{path}"
  # pp node.adjacent.map(&:to_s)
  node.adjacent.each do |edge|
    next if edge.value == 'start'

    if edge.small?
      next if path.count(edge.value) > 1

      smalls = path.select { |n| n.downcase == n }
      if smalls.uniq != smalls #there is already a duplicate
        next if path.include?(edge.value)
      end
    end

    new_path = path.dup
    new_path.push edge.value

    if edge.value == 'end'
      # pp "End reached, pushing #{path}"
      @paths.push new_path
      next
    end

    # pp "looking at edge #{edge.value}
    explore_cave_better(edge, new_path)
  end
end



explore_cave(caves.nodes['start'], path)
pp @paths.length

@paths = []
explore_cave_better(caves.nodes['start'], path)
# pp @paths.sort
pp @paths.length
