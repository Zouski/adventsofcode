filename = '10.txt'
input = File.open(filename).readlines.map(&:chomp)

rows = input.clone

closing_brackets = %w|] } > )|
pairs = %w|() [] <> {}|

score = 0

incompletes = []
rows.each do |row|
  last = row + ' '

  while last.length > row.length
    last = row.dup
    pairs.each do |pair|
      row.gsub!(pair, '')
    end
  end

  char = row[/[}>\]\)]/]
  if char
    score += 3 if char == ')'
    score += 57 if char == ']'
    score += 1197 if char == '}'
    score += 25137 if char == '>'
  else
    incompletes.push row.reverse
  end
end

pp score

scores = []
incompletes.each do |incomplete|
  score = 0
  incomplete.each_char do |c|
    score *= 5
    score += 1 if c == '('
    score += 2 if c == '['
    score += 3 if c == '{'
    score += 4 if c == '<'
  end

  scores.push score
end

scores.sort!
pp scores[scores.length / 2]
