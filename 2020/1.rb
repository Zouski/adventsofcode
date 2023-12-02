filename = '1.txt'
input = File.open(filename).readlines.map(&:chomp).map(&:to_i)

input.each_with_index do |a,i|
  input[i+1..-1].each do |b|
    if a + b == 2020
      pp a * b
    end
  end
end

input.each_with_index do |a,i|
  input[i+1..-1].each_with_index do |b,j|
    next if a + b > 1909

    input[i + j + 2..-1].each do |c|
      pp a * b * c if a + b + c == 2020
    end
  end
end