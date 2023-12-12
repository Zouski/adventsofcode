input = File.open('15.txt').readlines.first.split(',').map(&:to_i)

pp numbers = input

Number = Struct.new(:prev, :cur) do
  def speak(turn)
    self.prev = cur
    self.cur = turn
  end
end

@numbers = {}

def speak(number, turn)
  # pp "Speaking #{number} on turn #{turn}"
  if @numbers[number].nil?
    @numbers[number] = Number.new(-1, turn)
  else
    @numbers[number].speak(turn)
  end
end

numbers.each_with_index do |number, i|
  speak(number, i)
end

last_number = numbers.last

length = numbers.length
(30000000 - length).times do |i|
  if i % 1000000 == 0
    pp "Turn #{i}"
  end
  turn = i + length
  if @numbers[last_number].prev.negative?
    speak(0, turn)
    last_number = 0
  else
    to_speak = @numbers[last_number].cur - @numbers[last_number].prev
    speak(to_speak, turn)
    last_number = to_speak
  end

end

pp last_number
