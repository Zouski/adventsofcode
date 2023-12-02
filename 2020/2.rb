filename = '2.txt'
input = File.open(filename).readlines.map(&:chomp)

passwords = input.map { |i| i.scan(/(\d+)-(\d+) (.): (\S+)/).first }

good = 0
better = 0
passwords.each do |password|
  a, b, l, p = password
  good += 1 unless p.count(l) < a.to_i || p.count(l) > b.to_i
  better += 1 if (p[a.to_i-1] == l) ^ (p[b.to_i - 1] == l)
end

pp good
pp better