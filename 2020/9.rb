filename = '9.txt'
input = File.open(filename).readlines.map(&:chomp).map(&:to_i)

window = filename == '9e.txt' ? 5 : 25

target = 0
input[window..-1].each_with_index do |number, i|
  next unless (window - 1).times do |j|
    break unless (window - j - 1).times do |k|
      first = input[i + j]
      second = input[i + j + k + 1]
      break if first + second == number
    end
  end

  pp target = number
  break
end

input.each_with_index do |sum, i|
  agg = sum
  input[(i+1)..-1].each_with_index do |sum2, j|
    agg += sum2

    break if agg > target
    next unless agg == target

    range = input[i..i+j+1]
    pp range.min + range.max
    return 0
  end
end


