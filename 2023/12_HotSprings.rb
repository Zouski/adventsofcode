input = File.open('12e.txt').readlines.map(&:chomp)
# pp input
class String
  def shave
    gsub!(/^\.+/, '')
    gsub!(/\.+$/, '')
    gsub!(/\.{2,}/, '.')
    self
  end
end

def valid?(spring, attempt)
  spring.chars.each_with_index do |sc, i|
    next if sc == '?'

    return false if sc == '#' && attempt[i] == '.'
    return false if sc == '.' && attempt[i] == '#'
  end

  true
end

def generate_combos(original, numbers, length)
  return [length] if numbers == 1

  sets = []

  range = length - (numbers - 2)
  combos = []

  commence = numbers == original || numbers == 1 ? 0 : 1

  (commence..range).to_a.each do |number|
    generate_combos(original, numbers - 1, length - number).each do |combo|
      combos.push [number, combo].flatten
    end
  end

  combos
end

@debug = false



springs = []
springs2 = []
groupings = []
groupings2 = []

input.each do |line|
  line = line.split
  springs.push line.first.clone

  spring2 = ""
  5.times do
    spring2 += line.first.clone
  end
  springs2.push spring2


  grouping = line.last.split(',').map(&:to_i)
  groupings.push grouping.clone

  grouping2 = []
  5.times do
    grouping2 += grouping.clone
  end
  groupings2.push grouping2
end

# pp springs.map(&:shave)
# pp groupings

def hotsprings(spring, grouping)
  spring.shave
  return 1 if spring.length == grouping.sum + grouping.length - 1

  original = ""

  while original != spring
    # pp "start of while"
    # pp spring

    original = spring.clone
    spring.shave
    count = 0

    #eliminate useless ends that cant fit groupings
    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring.include? '.'
      if spring[0..spring.index('.')].length <= grouping.first
        spring = spring[spring.index('.') + 1..]
      end
    end

    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring.include? '.'
      if spring[spring.rindex('.')..].length <= grouping.last
        spring = spring[0..spring.rindex('.') - 1]
      end
    end

    #eliminate guaranteed hits when # is first or last
    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring[0] == '#'
      spring = spring[grouping.first + 1..]
      grouping = grouping.drop 1
    end
    return 1 if grouping.empty?

    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring[-1] == '#'
      spring = spring[0..spring.length - grouping.last - 2]
      grouping.pop
    end
    return 1 if grouping.empty?

    #eliminate full #=grouping when theres not enough ? before to fit anything else
    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring[0..grouping.first].include?('#') && spring.scan(/#+/).first.length == grouping.first
      spring = spring[spring.index(/#+/) + spring.scan(/#+/).first.length + 1..]
      grouping = grouping.drop 1
    end
    return 1 if grouping.empty?

    pp "#{count += 1} #{spring} #{grouping}" if @debug
    if spring[spring.length - grouping.last - 1..].include?('#') && spring.scan(/#+/).last.length == grouping.last
      spring = spring[0..spring.rindex(/#+/) - spring.scan(/#+/).last.length - 1]
      grouping.pop
    end
    return 1 if grouping.empty?

    # eliminate "?#.????????.###?.#?, [2, 1, 1, 1, 4, 2]" the 2s
    if spring.include?('.') && spring.include?('#')
      if spring[0..spring.index('.') - 1].length == grouping.first && spring[0..spring.index('.') - 1].include?('#')
        spring = spring[spring.index('.') + 1..]
        grouping = grouping.drop 1
      end
    end
    return 1 if grouping.empty?

    if spring.include?('.') && spring.include?('#')
      if spring[spring.rindex('.') + 1..].length == grouping.last && spring[spring.rindex('.') + 1..].include?('#')
        spring = spring[0..spring.rindex('.') - 1]
        grouping.pop
      end
    end
    return 1 if grouping.empty?


    # "start"
    # "??.#??.?.?#???????, [2, 1]"
    # "??.#??.?.?#???????, [2, 1]"
    # 0
    #
    # could do something here
  end


  # pp "#{spring}, #{grouping}"
  return 1 if spring.empty? || grouping.empty?

  if spring.chars.uniq == ['?'] && grouping.length == 1
    return spring.length - grouping.first + 1
  end

  if !spring.include?('.') && grouping.length == 1
    wiggle = grouping.first - (spring.rindex('#') - spring.index('#') + 1)

    length = wiggle + 1

    if (spring.rindex("#") + 1) < grouping.first
      length -= grouping.first - (spring.rindex("#") + 1)
    end

    if spring.index('#') + grouping.first > spring.length
      length -= spring.index('#') + grouping.first - spring.length
    end

    return length
  end

  pp "#{spring} #{grouping}"
  # ok brute force time
  length = spring.length - grouping.sum
  numbers = grouping.length + 1
  combos = generate_combos(numbers, numbers, length)

  possibles = 0
  combos.each do |combo|
    test = ""
    combo.each_with_index do |dots, i|
      test += '.' * dots
      test += '#' * grouping[i] unless i == grouping.length
    end

    # pp "combo is #{combo} tester is #{test}"
    # pp spring
    # pp test
    possibles += 1 if valid?(spring, test)
    # pp valid?(spring, test)
  end

  possibles
end


# we can consider lines solved if their length == minimum possible arrangement
# if not go from there...
# find hard placements, usually starting with the largest groups
# break down and recursively do parts

possibles = 0
springs.each_with_index do |spring, i|
  # pp "start"
  # pp "#{spring}, #{groupings[i]}"
  possibles += hotsprings(spring, groupings[i])
end

pp possibles


pp springs2
pp groupings2
possibles2 = 0
springs2.each_with_index do |spring, i|
  pp "start"
  pp "#{spring}, #{groupings2[i]}"
  pp possibles2 += hotsprings(spring, groupings2[i])
end

pp possibles2
