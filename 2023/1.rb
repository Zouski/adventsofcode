example = File.open("1.txt").readlines.map(&:chomp)

sum = 0
example.each do |line|
  first = 0
  last = 0

  line.each_char do |char|
    if char.to_i > 0
      first = char.to_i
      break
    end
  end

  line.reverse.each_char do |char|
    if char.to_i > 0
      last = char.to_i
      break
    end
  end

  num = first * 10 + last
  sum += num
end

pp sum


sum2 = 0


digits = %w[one two three four five six seven eight nine 1 2 3 4 5 6 7 8 9]

example.each do |line|
  lindexes = []
  rindexes = []
  lindexes = digits.each do |d|
    lindexes.push line.index d
    rindexes.push line.rindex d
  end

  #compact removes nil
  first = lindexes.index(lindexes.compact.min) % 9 + 1
  last = rindexes.index(rindexes.compact.max) % 9 + 1

  num = first * 10 + last
  sum2 += num
end

pp sum2





