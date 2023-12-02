filename = '5.txt'
input = File.open(filename).readlines.map(&:chomp)


scores = input.map do |ticket|
  ticket.gsub!(/[BFRL]/, 'B' => '1', 'F' => '0', 'R' => '1', 'L' => '0')
  row = ticket[0..6].to_i(2)
  column = ticket[7..9].to_i(2)
  row * 8 + column
end

pp scores.max
pp ((scores.min..scores.max).to_a - scores.sort).first