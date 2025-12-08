input = File.open('2024/13/13.txt').readlines.map(&:chomp)

# puts input
#i failed linear algebra

Config = Struct.new(:ax, :ay, :bx, :by, :px, :py)


configurations = []
config = []
input.each_with_index do |line, i|
  i = i % 4

  case i
  when 0
    config = []
    config << line[12..13].to_i
    config << line[18..19].to_i
  when 1
    config << line[12..13].to_i
    config << line[18..19].to_i
  when 2
    result = line.scan /\d+/
    config << result[0].to_i
    config << result[1].to_i
    configurations << Config.new(*config)
  else
    next
  end
end

# pp configurations

tokens = 0
configurations.each do |c|
  d = (c.ax * c.by) - (c.ay * c.bx)
  dx = (c.px * c.by) - (c.py * c.bx)
  dy = (c.ax * c.py) - (c.ay * c.px)

  a = dx / d
  b = dy / d
  # pp "ab #{a}, #{b}"
  if d * a == dx && d * b == dy
    tokens += a * 3 + b
  end
end

pp tokens

tokens = 0
configurations.each do |c|
  c.px += 10000000000000
  c.py += 10000000000000
  d = (c.ax * c.by) - (c.ay * c.bx)
  dx = (c.px * c.by) - (c.py * c.bx)
  dy = (c.ax * c.py) - (c.ay * c.px)

  a = dx / d
  b = dy / d
  # pp "ab #{a}, #{b}"
  if d * a == dx && d * b == dy
    tokens += a * 3 + b
  end
end
pp tokens
