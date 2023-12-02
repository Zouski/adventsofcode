example = File.open('2.txt').readlines.map(&:chomp)

# only 12 red cubes, 13 green cubes, and 14 blue cubes
MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14

def overcolour(number, colour)
  return true if colour == 'red' && number > MAX_RED
  return true if colour == 'green' && number > MAX_GREEN
  return true if colour == 'blue' && number > MAX_BLUE

  false
end

sum = 0
sum2 = 0

example.each_with_index do |game, i|
  valid = true
  local = {'red' => 0, 'green' => 0, 'blue' => 0}
  line = game.split(':').last.strip
  line.split(';').each do |round|
    round.split(',').each do |draw|
      number, colour = draw.split ' '
      local[colour] = number.to_i if number.to_i > local[colour]
      if overcolour(number.to_i, colour)
        valid = false
        # pp "game #{i+1} invalid because #{colour} #{number}"
      end
    end
  end
  sum += i + 1 if valid
  sum2 += local.values.inject(:*)
end

pp sum
pp sum2
