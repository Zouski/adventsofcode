filename = '6.txt'
input = File.open(filename).readlines.map(&:chomp).first.split(',').map(&:to_i)

@fishes = input.map(&:clone).sort

80.times do |i|
  count = []
  9.times do |i|
    count.push @fishes.count(i)
  end
  #pp "#{count}, #{@fishes.length}"
  @fishes.each_with_index do |fish,i|
    if fish.zero?
      @fishes[i] = 6
      @fishes.push 9
    else
      @fishes[i] = fish - 1
    end
  end
end

pp "original working count"
pp @fishes.length

@fishes = input.map(&:clone).sort
@count = []
9.times do |i|
  @count.push @fishes.count(i)
end
pp @count

256.times do
  #pp "#{@count}, #{@count.sum}"
  @count[7] += @count[0]
  @count.rotate!
end

pp @count, @count.sum
