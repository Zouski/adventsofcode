

example = File.read('2.txt')

scores = []
example.each_line do |line|
  score = 0
  line = line.split
  if line[0] == "A"
    score += 3 if line[1] == "X"
    score += 6 if line[1] == "Y"
  elsif line[0] == "B"
    score += 3 if line[1] == "Y"
    score += 6 if line[1] == "Z"
   else
     score += 3 if line[1] == "Z"
     score += 6 if line[1] == "X"
  end

  score += 1 if line[1] == "X"
  score += 2 if line[1] == "Y"
  score += 3 if line[1] == "Z"

  scores.push score
end

scores2 = []
example.each_line do |line|
  score = 0
  line = line.split
  if line[0] == "A"
    score += 3 if line[1] == "X"
    score += 1 if line[1] == "Y"
    score += 2 if line[1] == "Z"
  elsif line[0] == "B"
    score += 1 if line[1] == "X"
    score += 2 if line[1] == "Y"
    score += 3 if line[1] == "Z"
  else
    score += 2 if line[1] == "X"
    score += 3 if line[1] == "Y"
    score += 1 if line[1] == "Z"
  end

  score += 3 if line[1] == "Y"
  score += 6 if line[1] == "Z"
  scores2.push score
end

puts scores.sum
puts scores2.sum