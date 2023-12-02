example = File.read('8.txt')


board = []
example.each_line do |line|
  line.chomp!
  board.push line.split('').map!(&:to_i)
end


score_board = Array.new(board.size) { Array.new(board.first.size, 0) }


4.times do |i|
  board.each_with_index do |row, y|
    local_max = -1
    row.each_with_index do |tree, x|
      if tree > local_max
        #pp "#{x}, #{y}, #{tree}"
        #pp score_board
        score_board[y][x] = 1
        local_max = tree
      end
    end
  end
  board = board.transpose.map(&:reverse)
  score_board = score_board.transpose.map(&:reverse)
end

pp score = score_board.map(&:sum).sum
tree_board = Array.new(board.size) { Array.new(board.first.size, 1) }


4.times do
  board.each_with_index do |row, y|
    row.each_with_index do |house, x|
      x1 = x - 1
      vis_score = 0
      while x1 >= 0
        vis_score += 1
        break if board[y][x1] >= house

        x1 -= 1
      end
      tree_board[y][x] *= vis_score

    end
  end

  board = board.transpose.map(&:reverse)
  tree_board = tree_board.transpose.map(&:reverse)
end

#pp tree_board

pp tree_board.map(&:max).max