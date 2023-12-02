filename = '13.txt'
input = File.open(filename).readlines.map(&:chomp)

separator = input.find_index ''
dots = input[0..separator - 1]
instructions = input[separator + 1..-1]

dots.map! { |d| d.split(',').map(&:to_i) }

maxes = dots.transpose.map(&:max)
@sheet = Array.new(maxes[1] + 1) { Array.new(maxes[0] + 1, 0) }

def fold_sheet(instruction)
  mirror = nil
  original = nil
  axis = instruction.scan(/\d+/).first.to_i
  if instruction.include? 'y'
    original = @sheet.take axis
    mirror = @sheet.drop(axis + 1).reverse
  else
    original = @sheet.transpose.take(axis).transpose
    mirror = @sheet.transpose.drop(axis + 1).reverse.transpose
  end

  original.each_with_index do |row, y|
    row.each_with_index do |dot, x|
      original[y][x] = dot | mirror[y][x]
    end
  end

  original
end

dots.each do |dot|
  @sheet[dot[1]][dot[0]] = 1
end

pp fold_sheet(instructions.first).flatten.sum

instructions.each do |instruction|
  @sheet = fold_sheet instruction
end

@sheet.each_with_index do |row, y|
  row.each_with_index do |number, x|
    @sheet[y][x] = number.zero? ? ' ' : '#'
  end
end

pp @sheet.map(&:join)


