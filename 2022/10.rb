example = File.read('10e.txt')
file = File.open('10.txt')

cycle = 0
x = 1
xsum = 0

report_times = [20,60,100,140,180,220]

example.each_line do |line|
  line = line.split

  #pp "cycle: #{cycle} line: #{line} x: #{x}"

  if line[0] == "noop"
    if report_times.include? cycle
      pp "cycle #{cycle} register #{x}"
      pp x*(cycle)
      xsum += x*(cycle)
    end
    cycle += 1
  else
    if report_times.include? cycle+1
      pp "a cycle #{cycle+1} register #{x}"
      pp x*(cycle+1)
      xsum += x*(cycle+1)
    elsif report_times.include? cycle
     pp "b cycle #{cycle} register #{x}"
     pp x*(cycle)
     xsum += x*(cycle)
    end
    cycle += 2
    x += line[1].to_i
  end

end
pp xsum

x = 1
scores = []
cycle = 1
add = nil


screen = Array.new(6) { "." * 40 }

until file.eof?

  #pp "cycle #{cycle} x:#{x} add:#{add}"

  xr = (cycle - 1) % 40
  yr = (cycle - 1) / 40

  if (xr - x).abs <= 1
    screen[yr][xr] = "#"
  end

  if report_times.include? cycle
    scores.push cycle * x
  end

  if add.nil?
    instruction = file.readline.split
    if instruction[0] == "addx"
      add = instruction[1].to_i
    end
  else
    #add
    x += add
    add = nil
  end

  cycle += 1
end

pp cycle


pp scores
pp scores.sum


pp screen
