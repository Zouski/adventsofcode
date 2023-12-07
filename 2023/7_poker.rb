input = File.open('7.txt').readlines.map(&:chomp)
hands = input.map(&:split)

start = Time.now

hands.map! do |hand|
  hand.first.gsub!('J', 'b')
  hand.first.gsub!('Q', 'c')
  hand.first.gsub!('K', 'd')
  hand.first.gsub!('A', 'e')
  hand.first.gsub!('T', 'a')
  [hand.first, hand.last.to_i]
end

Hand = Struct.new(:cards, :bid) do
  attr_reader :strength, :value

  def initialize(cards, bid)
    super(cards, bid)

    hash = {}
    cards.each_char do |card|
      hash[card.to_sym] ||= 0
      hash[card.to_sym] += 1
    end

    @strength = case hash.keys.length
                when 1
                  7
                when 2
                  if hash.values.max == 4
                    6
                  else
                    5
                  end
                when 3
                  if hash.values.max == 3
                    4
                  else
                    3
                  end
                when 4
                  2
                else
                  1
                end

    @value = cards.to_i(16)
  end

  def <=>(other)
    return (strength <=> other.strength) unless (strength <=> other.strength).zero?

    value <=> other.value
  end
end

hands.map! do |hand|
  Hand.new(hand.first, hand.last.to_i)
end

hands.sort!

sum = 0
hands.each_with_index do |hand, i|
  sum += hand.bid * (i + 1)
end

joker_hands = input.map(&:split)

joker_hands.map! do |hand|
  hand.first.gsub!('J', '0')
  hand.first.gsub!('Q', 'c')
  hand.first.gsub!('K', 'd')
  hand.first.gsub!('A', 'e')
  hand.first.gsub!('T', 'a')
  [hand.first, hand.last.to_i]
end


JHand = Struct.new(:cards, :bid) do
  attr_reader :strength, :value

  def initialize(cards, bid)
    super(cards, bid)

    hash = {}
    jokers = 0
    cards.each_char do |card|
      if card == '0'
        jokers += 1
        next
      end
      hash[card.to_sym] ||= 0
      hash[card.to_sym] += 1
    end

    if jokers < 5
      max = hash.values.max + jokers
      @strength = case max
                  when 5
                    7
                  when 4
                    6
                  when 3
                    if hash.values.max(2).last == 2
                      5
                    else
                      4
                    end
                  when 2
                    if hash.values.max(2).last == 2
                      3
                    else
                      2
                    end
                  else
                    1
                  end
    else
      @strength = 7
    end

    @value = cards.to_i(16)
  end

  def <=>(other)
    return (strength <=> other.strength) unless (strength <=> other.strength).zero?

    value <=> other.value
  end
end

joker_hands.map! do |hand|
  JHand.new(hand.first, hand.last.to_i)
end

joker_hands.sort!

sum2 = 0
joker_hands.each_with_index do |hand, i|
  sum2 += hand.bid * (i + 1)
end

fin = Time.now

pp fin - start
pp sum
pp sum2