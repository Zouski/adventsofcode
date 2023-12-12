input = File.open('16.txt').readlines.map(&:chomp)

# pp input

rules = []
rule_names = []
tickets = []
my_ticket = nil
stage = 0
input.each do |line|
  if line.empty?
    stage += 1
    next
  end

  case stage
  when 0
    line = line.split(':')
    rule_names.push line.first
    text = line.last.split('or')
    rule = []
    text.each do |t|
      t = t.split('-').map(&:to_i)
      rule.push t.first..t.last
    end

    rules.push rule
  when 1
    next if line.include? 'y'

    my_ticket = line.split(',').map(&:to_i)
  else
    next if line.include? 'n'

    tickets.push line.split(',').map(&:to_i)
  end
end

# pp rules
# pp tickets

invalid_numbers = []
valid_tickets = []

tickets.each do |ticket|
  ticket_valid = true
  ticket.each do |number|
    invalid = true
    rules.each do |rule_pair|
      if rule_pair.first.cover?(number) || rule_pair.last.cover?(number)
        invalid = false
        break
      end
      break unless invalid
    end
    if invalid
      invalid_numbers.push number
      ticket_valid = false
    end
  end
  valid_tickets.push ticket if ticket_valid
end

pp invalid_numbers.sum

invalid_positions = []
rules.length.times do
  invalid_positions.push [false] * rules.length
end

valid_tickets.each do |numbers|
  # pp "inspecting ticket #{numbers}"
  numbers.each_with_index do |number, i|
    rules.each_with_index do |rule_pair, j|
      # pp "inspecting #{number} against #{rule_pair}"
      next if rule_pair.first.cover?(number) || rule_pair.last.cover?(number)

      # pp "invalid found at i#{i} j#{j}"
      invalid_positions[j][i] = true
    end
  end
end

translated_ticket = {}

while translated_ticket.length < rules.length
  solved_columns = []
  invalid_positions.each_with_index do |invalid_position, i|
    if invalid_position.count(false) == 1
      j = invalid_position.index(false)
      # pp "translating ticket. invalids #{invalid_position}, #{rule_names[j]}, #{my_ticket[i]}"

      translated_ticket[rule_names[i]] = my_ticket[j]
      solved_columns.push j
    end
  end

  invalid_positions.each do |position|
    solved_columns.each do |j|
      position[j] = true
    end
  end
end


# pp my_ticket

# pp translated_ticket

product = 1
translated_ticket.each do |name, value|
  product *= value if name.include? 'departure'
end

pp product
