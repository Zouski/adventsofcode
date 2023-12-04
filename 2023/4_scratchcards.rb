data = File.open('4.txt').readlines.map(&:chomp)

cards = data.map do |card|
  card = card.split(':').last
  card = card.split('|').map {|x| x.split(' ').map(&:to_i)}
end

sum = 0
scores = []
cards.each do |card|
  score = 0
  card.first.each do |winner|
    score += 1 if card.last.include? winner
  end
  sum += 2.pow(score - 1) if score > 0
  scores.push score
end

pp sum

copies = [1] * cards.length
scores.each_with_index do |score, i|
  score.times do |j|
    copies[i + j + 1] += copies[i]
  end
end

pp copies.sum

