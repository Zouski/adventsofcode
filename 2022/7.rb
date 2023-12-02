example = File.read('7.txt')

class Node
  attr_reader :name, :up
  attr_accessor :dirs, :files

  def initialize(name, up = nil)
    @name = name
    @up = up
    @dirs = []
    @files = {}
  end

  def filesize
    files.values.sum
  end
  
  def size
    @dirs.map(&:size).sum + filesize
  end

  def to_s
    attributes
  end
end

root = Node.new("/")
current = root

example.each_line do |line|
  line = line.split
  if line.first == "$" #command
    if line[1] == "cd"
      if line.last == "/"
        current = root
      elsif line.last == ".."
        current = current.up
      else
        dir = line.last
        current = current.dirs.find {|i| i.name == dir}
      end
    else #ls
      next
    end
  elsif line.first == "dir" #dir
    dir = line.last
    current.dirs.push Node.new(dir, current)
  else #file
    current.files[line.last] = line.first.to_i
  end
end

full_size = root.size
@under = 0

TOTAL_SIZE = 70000000
REQUIRED = 30000000
MAX_USED = TOTAL_SIZE - REQUIRED
OVER = full_size - MAX_USED

@smallest = TOTAL_SIZE

def sizeup(dir)
  dir.dirs.each do |d|
    if sizeup(d) <= 100000
      @under += d.size
    end
  end

  size = dir.size
  @smallest = size if size >= OVER && size < @smallest

  size
end

sizeup root
pp "full size #{full_size}"
pp "under #{@under}"
pp "over #{OVER}"
pp "smallest #{@smallest}"


