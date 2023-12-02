
file = File.open('11.txt')




Monkey = Struct.new(:list, :operand, :number, :test, :true, :false, :inspects)

monkeys = []
better_monkeys = []

until file.eof?
  file.readline #monkey
  list = file.readline.chomp[18..-1].split(', ').map(&:to_i)

  operation = file.readline
  operand = operation[23]
  number = operation[25..-1]
  if number.chomp == 'old'
    operand = 'squared'
  else
    number = number.to_i
  end

  test = file.readline[21..-1].chomp.to_i

  truth = file.readline[29..-1].chomp.to_i

  falser = file.readline[30..-1].chomp.to_i

  file.readline unless file.eof?

  monkeys.push Monkey.new(list.dup, operand, number, test, truth, falser, 0)
  better_monkeys.push Monkey.new(list.dup, operand, number, test, truth, falser, 0)
end

pp "original lists"
pp monkeys.map(&:list)
pp better_monkeys.map(&:list)



def operate(operand, a, b)
  if operand == '*'
    a * b
  elsif operand == '+'
    a + b
  else
    a * a
  end
end

20.times do |i|
  monkeys.each_with_index do |monkey, m|
    #pp "****************************  Round #{i}, Monkey #{m}!"
    monkey.list.each do |item|
      original = item
      item = operate(monkey.operand, item, monkey.number)
      operation = item
      item /= 3
      bored = item
      monkeys[(item % monkey.test).zero? ? monkey.true : monkey.false].list.push item
      monkey.inspects += 1
      #pp "Throwing #{original}:#{item} to monkey #{item % monkey.test == 0 ? monkey.true : monkey.false}"
      #pp "Operation: #{operation}, bored: #{bored}, question: #{item % monkey.test}"
    end
    monkey.list = []
  end

  #pp monkeys
end

pp "lists after dealing with monkeys"
pp monkeys.map(&:list)
pp better_monkeys.map(&:list)

pp monkeys.map(&:inspects)
pp monkeys.map(&:inspects).max(2).inject(&:*)

# pp better_monkeys
primer = better_monkeys.map(&:test).inject(&:*)
10000.times do |i|
  better_monkeys.each_with_index do |monkey, m|
    # pp "****************************  Round #{i}, Monkey #{m}!"
    # pp monkey.list
    monkey.list.each do |item|
      item = operate(monkey.operand, item, monkey.number)
      better_monkeys[(item % monkey.test).zero? ? monkey.true : monkey.false].list.push (item % primer)
      monkey.inspects += 1
    end
    monkey.list = []
  end

  #pp monkeys
  #

  rounds = [1, 20, 1000, 2000, 3000, 4000, 5000]
  if rounds.include? i+1
    # pp "******** ROUND #{i+1}"
    # pp better_monkeys.map(&:inspects)
  end
end

pp better_monkeys.map(&:inspects)
pp better_monkeys.map(&:inspects).max(2).inject(&:*)