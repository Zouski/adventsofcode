filename = '8.txt'
input = File.open(filename).readlines.map(&:chomp)

codes = input.map do |code|
  code.split('|').map(&:split)
end

count = 0
codes.each_with_index do |code, i|
  code[1].each do |number|
    count += 1 if [2, 3, 4, 7].include? number.length
  end
end

pp count

finals = codes.map do |code|
  dictionary = Array.new 9
  info = code.first
  numbers = code[1].map { |n| n.split('') }.map(&:sort)

  dictionary[1] = info.select { |i| i.length == 2 }.first.split('').sort
  dictionary[4] = info.select { |i| i.length == 4 }.first.split('').sort
  dictionary[7] = info.select { |i| i.length == 3 }.first.split('').sort
  dictionary[8] = info.select { |i| i.length == 7 }.first.split('').sort

  fives = info.select { |i| i.length == 5 }.map { |j| j.split('') }.map(&:sort)

  dictionary[3] = fives.select { |five| dictionary[1] - five == [] }.first
  fives.delete dictionary[3]
  dictionary[2] = fives.select { |five| (five - dictionary[4]).length == 3 }.first
  fives.delete dictionary[2]
  dictionary[5] = fives.first.sort

  sixes = info.select { |i| i.length == 6 }.map { |j| j.split('') }.map(&:sort)

  dictionary[9] = sixes.select { |six|  (six - dictionary[4]).length == 2 }.first
  sixes.delete dictionary[9]
  dictionary[6] = sixes.select { |six|  (six - dictionary[7]).length == 4 }.first
  sixes.delete dictionary[6]
  dictionary[0] = sixes.first.sort


  mult = 1000
  final = 0
  numbers.each do |number|
    dictionary.each_with_index do |dict, i|
      next unless number == dict

      final += i * mult
      mult /= 10
      break
    end
  end

  final
end

pp finals.sum







