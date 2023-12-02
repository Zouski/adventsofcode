filename = '14.txt'
input = File.open(filename).readlines.map(&:chomp)

@pairs = {}
@molecule = input.first.split('')
first = @molecule[0]
@molecule[1..-1].each do |atom|
  @pairs[first + atom] ||= 0
  @pairs[first + atom] += 1
  first = atom
end

@rules = {}
input[2..-1].each do |rule|
  rule = rule.split ' -> '
  @rules[rule.first] = [rule.first[0] + rule.last, rule.last + rule.first[1]]
end

def step
  @pairs.dup.each do |key, value|
    next unless value.positive?

    @rules[key].each do |pair|
      @pairs[pair] ||= 0
      @pairs[pair] += value
    end
    @pairs[key] -= value
  end
end

def count_atoms
  atoms = {}
  @pairs.each do |pair, amount|
    pair = pair.split ''
    pair.each do |atom|
      atoms[atom] ||= 0
      atoms[atom] += amount
    end
  end

  atoms.each_key do |atom|
    atoms[atom] /= 2
  end

  atoms[@molecule.first] += 1
  atoms[@molecule.last] += 1
  atoms
end

10.times do
  step
end

atoms = count_atoms
pp atoms.values.max - atoms.values.min

30.times do
  step
end

atoms = count_atoms
pp atoms.values.max - atoms.values.min
