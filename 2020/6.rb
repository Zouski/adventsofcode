filename = '6.txt'
input = File.open(filename).readlines.map(&:chomp)

count = 0
groups = ['']
mobs = [[]]

input.each do |person|
  if person == ''
    count += 1
    groups[count] = ''
    mobs[count] = []
  else
    groups[count] += person
    mobs[count].push person
  end
end

score = 0
groups.each do |group|
  ('a'..'z').each { |l| score += 1 if group.include? l }
end
pp score

mob_score = 0
mobs.each do |mob|
  ('a'..'z').each do |l|
    results = mob.map { |person| person.include? l }
    mob_score += 1 if results.all?(true)
  end
end
pp mob_score