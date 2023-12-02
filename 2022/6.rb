example = File.read('6.txt')
#example = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

example.length.times do |i|
  code = example[i..i+3]
  if code.count(code[0]) == 1 && code.count(code[1]) == 1 && code.count(code[2]) == 1 && code.count(code[3]) == 1
    puts i + 3

    break
  end
end

example.length.times do |i|
  code = example[i..i+13]

  bad = false
  code.each_char do |char|
    if code.count(char) != 1
      bad = true
      break
    end
  end

  unless bad
    puts code
    puts i + 14
    break
  end
end