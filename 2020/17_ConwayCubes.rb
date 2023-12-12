input = File.open('17e.txt').readlines.map(&:chomp)

pp input

class Board
  SIZE = 20 # Change to your desired size
  CENTER = SIZE / 2

  def initialize
    @grid = Array.new(SIZE) { Array.new(SIZE) { Array.new(SIZE, '.') } }
  end

  def get(x, y, z)
    @grid[z + CENTER][y + CENTER][x + CENTER]
  end

  def set(x, y, z, value)
    @grid[z + CENTER][y + CENTER][x + CENTER] = value
  end

  def display
    @grid.each_with_index do |xy_layer, z|
      puts "z = #{z - CENTER}"
      xy_layer.reverse.each_with_index do |row, y|
        puts ("%03d" % y) + row.join(' ')
      end
      puts "\n"
    end
  end

  def count_neighbours(x, y, z)
    count = 0
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        (-1..1).each do |dz|
          next if dx.zero? && dy.zero? && dz.zero?

          nx = x + dx
          ny = y + dy
          nz = z + dz
          next if nx.abs > CENTER || ny.abs > CENTER || nz.abs > CENTER

          count += 1 if get(nx, ny, nz) == '#'
          return count if count == 4
        end
      end
    end
    count
  end

  def populate_z0(grid_2d)
    xy_layer = @grid[CENTER]
    length = (grid_2d.length - 1) / 2
    pp "Length #{length}"

    xy_layer[CENTER - length..CENTER + length].each_with_index do |row, y|
      grid_2d[y].each_with_index do |g_x, x|
        next if g_x == '.'
        set(x - length, y - length, 0, '#')
      end
    end
  end

  def display_z(z)
    xy_layer = @grid[z - CENTER]
    puts "z = #{z}"
    xy_layer.reverse.each_with_index do |row, y|
      puts ("%03d" % (-(y - CENTER))) + row.join(' ')
    end
  end
end

board = Board.new

original_state = input.map(&:chars)




board.populate_z0(original_state)
board.display_z(0)
pp original_state
