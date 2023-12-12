input = File.open('9.txt').readlines.map(&:chomp).map(&:split)

# pp input

def get_dif(arr)
  return 0 if arr.uniq == [0]

  arr.last + get_dif(arr.each_cons(2).map { |a, b| b - a })
end

difs = []
pres = []
input.each do |line|
  line.map!(&:to_i)

  difs.push get_dif(line)
  pres.push get_dif(line.reverse)
end

pp difs.sum
pp pres.sum
