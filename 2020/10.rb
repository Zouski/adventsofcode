filename = '10.txt'
input = File.open(filename).readlines.map(&:chomp).map(&:to_i).sort
pp input

input.insert(0, 0)
input.push input.last + 3

one = 0
three = 0

(input.length - 1).times do |i|
  one += 1 if input[i + 1] - input[i] == 1
  three += 1 if input[i + 1] - input[i] == 3
end

pp one, three
pp one * three

class Integer
  def magic
    return 1 if self < 2
    return 2 if self == 2
    return 4 if self == 3
    return 7 if self > 3
  end
end


groups = [0]
count = 0
(input.length - 1).times do |i|
  if input[i + 1] - input[i] == 1
    groups[count] += 1
  else
    groups.push 0
    count += 1
  end
end

pp "three 2s four 7s"
pp groups.sort
pp -1.magic
pp 0.magic
pp 1.magic
pp 2.magic
pp 3.magic
pp 4.magic
pp 5.magic
pp 6.magic

agg = 1
groups.each do |group|
  agg *= group.magic
end

pp agg




#
# 1.1
# 2.2
# 3.4
# 4.7
# 5.13
#
# 0.0 3 6: 0 apart from main
# 1.0 34 7: 0
# 2.0 345 8: 1
#   0358
# 3.0 3456 9: 3
#   03569
# 03469
# 0369
#
# 4. 0 34567 10: 6
# 03 56 7
# 03 46 7
# 03 45 7
# 03 4 7
# 03 5 7
# 03 6 7
#
#
# 5.03 4567 8 11: 12
# 567
# 467
# 457
# 456
# 45
# 46
# 47
# 56
# 57
# 67
# 5
# 6
#
# 6. 03 45678 9 12:
#   x4
# x5
# x6
# x7
# x8
# x45
# x46
# x47
# x48
#
