filename = '12.txt'
input = File.open(filename).readlines.map(&:chomp)

#pp input

direction = 90 # east
north = 0
east = 0

input.each do |instruction|
  letter = instruction[0]
  amount = instruction.delete(letter).to_i

  #pp "instruction is #{letter} #{amount}"

  if letter == 'N'
    north += amount
  elsif letter == 'S'
    north -= amount
  elsif letter == 'E'
    east += amount
  elsif letter == 'W'
    east -= amount
  elsif letter == 'L'
    direction -= amount
  elsif letter == 'R'
    direction += amount
  else # F
    if direction % 360 == 0
      north += amount
    elsif direction % 360 == 90
      east += amount
    elsif direction % 360 == 180
      north -= amount
    else #270
      east -= amount
    end
  end

  #pp "north #{north}, east #{east}, direction #{direction}"
end

pp north.abs + east.abs
# 9385 too high

pp input
waypoint_east = 10
waypoint_north = 1
north = 0
east = 0

input.each do |instruction|
  letter = instruction[0]
  amount = instruction.delete(letter).to_i

  #pp "instruction is #{letter} #{amount}"

  if letter == 'N'
    waypoint_north += amount
  elsif letter == 'S'
    waypoint_north -= amount
  elsif letter == 'E'
    waypoint_east += amount
  elsif letter == 'W'
    waypoint_east -= amount
  elsif letter == 'F'
    north += waypoint_north * amount
    east += waypoint_east * amount
  elsif amount == 180
    waypoint_north *= -1
    waypoint_east *= -1
  elsif (letter == 'R' && amount == 90) || (letter == 'L' && amount == 270)
    temp_north = waypoint_north
    waypoint_north = waypoint_east * -1
    waypoint_east = temp_north
  else
    temp_north = waypoint_north
    waypoint_north = waypoint_east
    waypoint_east = temp_north * -1
  end

  #pp "north #{north}, east #{east}, direction #{direction}"
end

pp north, east, north.abs + east.abs