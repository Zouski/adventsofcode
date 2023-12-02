filename = '4.txt'
input = File.open(filename).readlines.map(&:chomp)
pp input

passports = []
passports[0] = ''
count = 0
input.each do |line|
  if line == ''
    count += 1
    passports[count] = ''
    next
  end
  passports[count] += " #{line}"
end

fields = %w[byr iyr eyr hgt hcl ecl pid]

passports.delete_if do |passport|
  (passport.scan(/([a-z]{3}):\S+/).flatten & fields).sort != fields.sort
end

pp passports.length

good = 0
passports.each do |passport|
  hash = {}
  passport.scan(/([a-z]{3}):(\S+)/).each do |pair|
    hash[pair[0]] = pair[1]
  end

  hash.delete 'cid'

  pp hash

  valid = hash.map do |field, value|
    case field
    when 'byr'
      value.to_i >= 1920 && value.to_i <= 2002
    when 'iyr'
      value.to_i >= 2010 && value.to_i <= 2020
    when 'eyr'
      value.to_i >= 2020 && value.to_i <= 2030
    when 'hgt'
      if value.delete! 'cm'
        value.to_i >= 150 && value.to_i <= 193
      elsif value.delete! 'in'
        value.to_i >= 59 && value.to_i <= 76
      else
        false
      end
    when 'hcl'
      !value[/#\h{6}/].nil?
    when 'ecl'
      %w[amb blu brn gry grn hzl oth].include? value
    when 'pid'
      value[/\d{9}/] && value.length == 9
    end
  end
  pp valid

  good += 1 if valid.all? true
end

pp good
#134 too low

