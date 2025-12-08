input = File.open('2024/7/7.txt').readlines.map(&:chomp)



def compute2(eq)
  result = eq.first
  nums = eq.last

  operate2(result, nums.first, nums[1..])
end

def operate2(result, current, nums)
  return 0 if current > result

  if nums.length == 0
    if current == result
      return 1
    end
    return 0
  end

  first = nums.first
  rest = nums[1..]
  count = 0
  count += operate2(result, current + first, rest)
  count += operate2(result, current * first, rest)
  exponent = first.to_s.length
  combo = current * 10.pow(exponent) + first
  # pp "exponent of first #{first} is #{exponent}"
  # pp "calling #{result}, #{combo}, #{rest}, with current #{current} first #{first}"
  count += operate2(result, combo, rest)
  count
end

def compute(eq)
  result = eq.first
  nums = eq.last

  operate(result, nums.first, nums[1..])
end

def operate(result, current, nums)
  return 0 if current > result

  if nums.length == 0
    if current == result
      return 1
    end
    return 0
  end

  first = nums.first
  rest = nums[1..]
  count = 0
  count += operate(result, current + first, rest)
  count += operate(result, current * first, rest)
  count
end


pp input

eqs = []
input.each do |line|
  result, nums = line.split(':')
  nums = nums.chomp.split(' ').map(&:to_i)
  eqs.append [result.to_i, nums]
end

pp eqs

solutions1 = 0
sum1 = 0
eqs.each do |eq|
  result = compute(eq)
  solutions1 += result
  if result > 0
    sum1 += eq.first
  end
end

solutions2 = 0
sum2 = 0
eqs.each do |eq|
  result = compute2(eq)
  solutions2 += result
  if result > 0
    sum2 += eq.first
  end
end

pp solutions1
pp sum1

pp solutions2
pp sum2