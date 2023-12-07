input = File.open('6.txt').readlines.map(&:chomp)

times = input.first.split.drop(1).map(&:to_f)
dists = input.last.split.drop(1).map(&:to_f)

pp times
pp dists

# race distance = (race_time - button_time) * button_time
# find all discrete button_times > dist
# can calculate second half of parabola
# (-b±√(b²-4ac))/(2a)
# c = -dist
# a = -1
# b = race_time

start = Time.now

def quadratic_formula(b, c)
  (-b + Math.sqrt(b**2 - (c * -4))) / -2
end

powers = []
times.each_with_index do |time, i|
  dist = dists[i]


  quad = quadratic_formula(time, -dist)
  quad += 1 if (quad % 1).zero?
  equation = (((time / 2) - quad.ceil).ceil * 2) + (1 - (time % 2))
  powers.push equation.to_i
end



time = input.first[10..].gsub(' ', '').to_i
dist = input.last[10..].gsub(' ', '').to_i

quad = quadratic_formula(time, -dist)
quad += 1 if (quad % 1).zero?
equation = (((time / 2) - quad.ceil).ceil * 2) + (1 - (time % 2))

fin = Time.now

pp "Time: #{fin - start}"
pp powers.inject(:*)
pp equation
