input = File.open('2024/9/9.txt').readlines.map(&:chomp)
input = input.first
# pp input

def space_search(size, index_of_file, spaces)
  spaces.each_with_index do |space, i|
    return nil if index_of_file < space[1]
    if space.first >= size
      space << i
      return space
    end
  end
  nil
end

def display(arr)
  pp arr.map { |n| n == -1 ? 0 : n}
end

mega = []
id = 0
spaces = []
mode = false #false is file, true is space
files = []
input.chars.each do |char|
  num = char.to_i
  if mode #space
    index = mega.length
    spaces << [num, index]
    num.times {mega << -1}
  else #file
    files << [num, mega.length, id]
    num.times { mega << id }
    id += 1
  end
  mode = !mode
end

vega = mega.dup

spaces_count = mega.count -1

spaces_count.times do
  mega[mega.index(-1)] = mega.pop
end
# pp mega

sum = 0
mega.each_with_index do |id, i|
  sum += id * i
end

pp sum

# display vega
# pp files
# pp spaces

files.reverse.each do |file|
  file_size = file[0]
  file_index = file[1]
  file_id = file[2]
  space = space_search(file_size, file_index, spaces)
  next if space.nil?

  space_size = space[0]
  space_index = space[1]
  space_j_index = space[2]

  file_size.times do |i|
    vega[space_index + i] = file_id
    vega[file_index + i] = -1
  end


  new_space_size = space_size - file_size
  new_space_index = space_index + file_size
  new_space = [new_space_size, new_space_index]
  spaces[space_j_index] = new_space
end
# pp spaces
# display vega

second = 0
vega.each_with_index do |id, i|
  second += id * i if id != -1
end

pp second