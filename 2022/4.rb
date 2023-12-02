example = File.read('4.txt')

score = 0
example.each_line do |line|
  line = line.split(',')
  a = line[0].split('-').map!(&:to_i)
  b = line[1].split('-').map!(&:to_i)

  if (a.first <= b.first && a.last >= b.last) || (b.first <= a.first && b.last >= a.last)
    #puts "match on #{a} and #{b}"
    score += 1
  end
end

puts score


score = 0
example.each_line do |line|
  line = line.split(',')
  a = line[0].split('-').map!(&:to_i)
  b = line[1].split('-').map!(&:to_i)


  puts "#{a}, #{b}"



  if a.first <= b.first
    if a.last >= b.first
      score += 1
      puts "overlap"
    end
  else
    if b.last >= a.first
      score += 1
      puts "overlap"
    end
  end


end

puts score
