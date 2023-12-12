input = File.open('14.txt').readlines.map(&:chomp)

commence = Time.now
original_mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
mem = {}

@mem2 = {}

def write(address, value)
  if address.include? 'X'
    index = address.index 'X'
    send_address = address.clone
    send_address[index] = '0'
    write(send_address, value)
    send_address[index] = '1'
    write(send_address, value)
  else
    @mem2[address.to_i(2)] = value
  end
end

input.each do |line|
  if line[0..1] == 'ma'
    mask = line[7..]
  else
    binary = line.split.last.chomp.to_i.to_s(2)
    value = original_mask.clone
    value[36 - binary.length..] = binary
    masked = value.clone
    #mask it
    36.times do |i|
      next if mask[i] == 'X'

      masked[i] = mask[i]
    end

    address = (line[4..line.index(']') - 1]).to_i
    mem[address] = masked.gsub('X', '0').to_i(2)

    #part 2
    address = line[4..line.index(']') - 1]
    bit_address = address.to_i.to_s(2)
    value = line.split('=').last[1..].to_i

    bit_address = '0' * (36 - bit_address.length) + bit_address

    masked_address = bit_address
    36.times do |i|
      next if mask[i] == '0'

      masked_address[i] = mask[i]
    end

    write(masked_address, value)
  end
end

fin = Time.now
pp fin - commence
pp mem.values.sum
pp @mem2.values.sum
