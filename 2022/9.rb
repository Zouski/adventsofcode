example = File.read('9.txt')



Knot = Struct.new(:x, :y)

head = Knot.new(0, 0)
tail = Knot.new(0, 0)

tail_pos = {0 => [0]}

tail_tracker = {0 => [0]}

def tailcheck(head, tail)
  (head.x - tail.x).abs > 1 || (head.y - tail.y).abs > 1
end



example.each_line do |line|
  line = line.split
  line[1] = line.last.to_i
  if line.first == "U"
    line.last.times do
      head.x += 1
      if tailcheck(head, tail)
        tail.x = head.x - 1
        tail.y = head.y
        tail_pos[tail.x] ||= []
        tail_pos[tail.x].push tail.y
      end
    end
  elsif line.first == "R"
    line.last.times do
      head.y += 1
      if tailcheck(head, tail)
        tail.x = head.x
        tail.y = head.y - 1
        tail_pos[tail.x] ||= []
        tail_pos[tail.x].push tail.y
      end
    end
  elsif line.first == "D"
    line.last.times do
      head.x -= 1
      if tailcheck(head, tail)
        tail.x = head.x + 1
        tail.y = head.y
        tail_pos[tail.x] ||= []
        tail_pos[tail.x].push tail.y
      end
    end
  else # L
    line.last.times do
      head.y -= 1
      if tailcheck(head, tail)
        tail.x = head.x
        tail.y = head.y + 1
        tail_pos[tail.x] ||= []
        tail_pos[tail.x].push tail.y
      end
    end

  end
end

pp tail_pos.values.map(&:uniq).map(&:count).sum


def tailmove(head, tail, orig)
  if tailcheck(head, tail)
    oldpos = tail.clone
    tail = orig
  end
  oldpos
end

rope = Array.new(10) { Knot.new(0,0) }

tail_tail = {0 => [0]}

example.each_line do |line|
  line = line.split
  line[1] = line[1].to_i

  line[1].times do
    if line.first == "U"
      rope.first.y += 1
    elsif line.first == "R"
      rope.first.x += 1
    elsif line.first == "D"
      rope.first.y -= 1
    else
      rope.first.x -= 1
    end

    9.times do |i|
      break unless tailcheck(rope[i], rope[i+1])

      if rope[i].x == rope[i+1].x
        rope[i+1].y += rope[i].y > rope[i+1].y ? 1 : -1
      elsif rope[i].y == rope[i+1].y
        rope[i+1].x += rope[i].x > rope[i+1].x ? 1 : -1
      else
        rope[i+1].x += rope[i].x > rope[i+1].x ? 1 : -1
        rope[i+1].y += rope[i].y > rope[i+1].y ? 1 : -1
      end

      if i == 8
        tail_tail[rope[i+1].x] ||= []
        tail_tail[rope[i+1].x].push rope[i+1].y
      end
    end
  end
  #pp rope
end

#art = Array.new(30) { Array.new(30,'.')}
#pp tail_tail


# tail_tail.each do |key, values|
#   values.uniq.each do |value|
#     art[key+15][value+15] = "#"
#   end
# end

#puts art.map(&:to_s)

pp tail_tail.values.map(&:uniq).map(&:count).sum