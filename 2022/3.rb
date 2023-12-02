example = File.read('3.txt')


puts example

puts "****"
errors = []
example.each_line do |line|
  length = line.length
  puts line
  a =  line[0..length/2 - 1]
  b =  line[length/2..length-1]

  a.each_char do |c|
    if b.include? c
      errors.push c
      break
    end
  end
end

puts errors
score = 0
errors.each do |error|
  score += if error.ord < 97
             error.ord - 38
           else
             error.ord - 96
           end

end
puts score


badges = []
example = example.split( "\n")
example.each_slice(3) do |slice|
  slice[0].each_char do |c|
    if slice[1].include?(c)&& slice[2].include?(c)
      badges.push c
      break
    end
  end
end

puts badges

score = 0
badges.each do |error|
  score += if error.ord < 97
             error.ord - 38
           else
             error.ord - 96
           end

end
puts score