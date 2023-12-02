filename = '7.txt'
input = File.open(filename).readlines.map(&:chomp)

rules = {}
input.each do |rule|
  rule = rule.scan(/([a-z]+ [a-z]+) bag/).flatten
  next if rule.last == 'no other'

  rules[rule.first] = rule[1..-1]
end

includes = 0
last = -1
shiny = ['shiny gold']

while(includes > last)
  last = includes
  rules.each do |bag, hold|
    if (!shiny.include? bag) && !(hold & shiny).empty?
      includes += 1
      shiny.push bag
    end
  end
end

pp shiny.length - 1

rules = {}
input.each do |rule|
  next unless rule =~ /\d/

  names = rule.scan /[a-z]+ [a-z]+/
  numbers = rule.scan /\d/

  rules[names.first] = {}
  names[2..-1].each_with_index do |name, i|
    rules[names.first][name] = numbers[i].to_i
  end
end

def add_bag(tree, bag)
  tree[bag] = {}
  @rules[bag].to_h.each do |sack, count|
    tree[bag][sack] = add_bag(tree[bag], sack)
  end
  return tree[bag]
end

@rules = rules
@tree = {}
@score = 0

bag = 'shiny gold'
pp rules

@tree = { 'shiny gold' => add_bag(@tree, bag) }
pp @tree


def combine_bags(tree, parent, multi)
  return if tree.nil?
  pp "I have looked into #{parent} * #{multi} and I see #{tree.keys}, I will count them"
  tree.keys.each do |key|
    @score += @rules[parent][key] * multi
    pp "counting #{key}, there are #{@rules[parent][key]} * #{multi} for #{@score}"
    pp "I will look into #{key}, I wonder whats inside..."
    combine_bags(tree[key], key, multi * @rules[parent][key])
  end
end

pp @tree
combine_bags(@tree[bag], bag, 1)

pp @score

#152008 too high
# 763 too low