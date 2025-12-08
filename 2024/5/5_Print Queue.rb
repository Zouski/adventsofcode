input = File.open('2024/5/5.txt').readlines.map(&:chomp)

pp input

i = input.index ""

instructions = input[..(i-1)]
lists = input[(i+1)..]

pp instructions
pp lists

map = {}

instructions.each do |inst|
  bef = inst[0..1].to_i
  aft = inst[3..4].to_i

  map[aft] ||= []
  map[aft].append bef unless map[aft].include? bef
end

pp map

count = 0
goods = []
bads = []
lists.each do |list|
  list = list.split(',').map(&:to_i)
  good = true
  list[0,list.length - 1].each_with_index do |x, i|
    if !map[x].nil? && (list[i, list.length - i] & map[x]).any?
      good = false
      break
    end
  end
  if good
    count += 1
    goods.append list
  else
    bads.append list
  end
end

pp bads.first
good = false
until good
  good = true
  bads.each do |list|
    list[0,list.length - 1].each_with_index do |x, i|
      combo = (list[i, list.length - i] & map[x])
      if !map[x].nil? && combo.any?
        good = false
        list.delete_at i
        list.insert(list.index(combo.last)+1, x)
        break
      end
    end
  end
end
pp bads.first

pp count

sum = 0
goods.each do |good|
  sum += good[good.length/2].to_i
end

badsum = 0
bads.each do |bad|
  badsum += bad[bad.length/2].to_i
end

pp sum
pp badsum