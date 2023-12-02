filename = '8.txt'
input = File.open(filename).readlines.map(&:chomp).map(&:split)

@inst = []
input.each do |instruction|
  @inst.push [instruction[0], instruction[1].to_i, 0]
end
@original_instructions = @inst.map(&:clone)

@acc = 0
@pointer = 0

def execute_instruction
  @inst[@pointer][2] += 1
  if @inst[@pointer].first == 'nop'
    @pointer += 1
  elsif @inst[@pointer].first == 'acc'
    @acc += @inst[@pointer][1]
    @pointer += 1
  else
    @pointer += @inst[@pointer][1]
  end
end

while(@inst[@pointer][2] != 1)
  execute_instruction
end

pp @acc
@acc = 0
@pointer = 0
target = @inst.length

@inst.each_with_index do |inst, i|
  @acc = 0
  @pointer = 0
  next if inst.first == 'acc'

  @inst = @original_instructions.map(&:clone)

  @inst[i][0] = @inst[i].first == 'jmp' ? 'nop' : 'jmp'

  while true
    execute_instruction
    if @pointer == target
      pp @acc
      break
    elsif @inst[@pointer][2] == 1
      break
    elsif @pointer > target
      break
    elsif @pointer.negative?
      break
    end
  end
end

pp "end"







