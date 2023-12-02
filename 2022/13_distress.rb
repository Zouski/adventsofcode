require 'json'
file = File.open('13.txt')

left = []
right = []

BOOLEANS = [true, false]

loop do
  left.push JSON.parse file.readline.chomp
  right.push JSON.parse file.readline.chomp
  break if file.eof?

  file.readline
end

# pp left
# pp right

corrects = []

def compare(left, right)
  if left.class == Integer && right.class == Integer
    return nil if left == right

    left < right
  elsif left.class == Array && right.class == Array
    minsize = [left.size, right.size].min
    minsize.times do |i|
      result = compare(left[i], right[i])
      return result if BOOLEANS.include? result
    end
    return nil if left.size == right.size

    left.size < right.size

  elsif left.class == Array
    compare(left, [right])
  else
    compare([left], right)
  end
end

truths = []
left.size.times do |i|
  truths.push i + 1 if compare(left[i], right[i])
end

# pp truths
pp truths.sum

full = left + right
full.push [[2]]
full.push [[6]]

# pp full

full.sort! { |x, y| compare(x, y) ? -1 : 1}

pp (full.index([[2]]) + 1) * (full.index([[6]]) + 1)

