
@lines
@map

class Array
  def delete_diagonals
    delete_if { |a| !(a[0] == a[2] || a[1] == a[3]) }
  end
end

def populate(filename)
  input = File.open(filename).readlines.map(&:chomp)
  @lines = []
  input.each do |line|
    line = line.scan(/(\d+),(\d+) -> (\d+),(\d+)/).first.map(&:to_i)
    if (line[0] == line[2] || line[1] == line[3])
      line[0], line[2] = line[2], line[0] if line[0] > line[2]
      line[1], line[3] = line[3], line[1] if line[1] > line[3]
    elsif line[0] > line[2]
      line[0], line[1], line[2], line[3] = line[2], line[3], line[0], line[1]
    end
    @lines.push line
  end

  max = @lines.map(&:max).max + 1
  @map = Array.new(max) { Array.new(max, 0) }
end

def draw_lines
  @lines.each do |line|
    if line[0] == line[2]
      (line[1]..line[3]).each do |i|
        @map[i][line[0]] += 1
      end
    elsif line[1] == line[3]
      (line[0]..line[2]).each do |i|
        @map[line[1]][i] += 1
      end
    else
      (line[0]..line[2]).each_with_index do |n,i|
        i *= -1 if line[1] > line[3]
        @map[line[1] + i][n] += 1
      end
    end
  end
end

def count_intersections
  count = 0
  @map.each do |row|
    row.each do |number|
      count += 1 if number > 1
    end
  end
  count
end

populate('5e.txt')
@lines.delete_diagonals
draw_lines
pp count_intersections

populate('5.txt')
draw_lines
pp count_intersections

