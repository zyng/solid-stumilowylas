#----------------------------------------------
# TicTacToe game in Ruby Language
# author: [Sanosh Wadghule, santosh.wadghule@gmail.com]
# copyright: (c) 2011 Santosh Wadghule
#----------------------------------------------

class Player

  def mark
    @mark
  end

  def mark=(mark)
    @mark = mark
  end

  def initialize(mark) # initialize Player's Mark (i.e "X" or "O")
    @mark = mark
  end


  def check_end(boards,engines)
    winner = engines.check_winner(boards)
    if winner != "No One"
      boards.display
      engines.display_winner(self.mark)
    end
  end

  def move(board, position, engine) # X player move
    board.positions_with_values[position] = self.mark
    board.display
    check_end(board,engine)
  end

  def best_move(board, engine) # Robot's (O Player) best move, includes artificial intelligence
    puts "\nRobot (O player) is taking turn..."

    sleep 2

    position = check_priority(board, engine, 'O')

    board.positions_with_values["#{position}"] = "O"

    check_end(board,engine)

    board.display
  end

  private

  def check_priority(board, engine, current_player) # artificial intelligence logic comes here
    return score(board, engine) if engine.check_winner(board) != "No One"

    scores = {}

    board.available_spaces.each do |space|
      potential_board = board.dup
      potential_board.place_piece(space, current_player)
      scores[space] = check_priority(potential_board, engine, switch(current_player))
    end

    best_score = the_best_move(current_player, scores)
    return best_score
  end

  def score(board, engine)
    if engine.check_winner(board) == 'O'
      return 10
    elsif engine.check_winner(board) == 'X'
      return -10
    end
    0
  end

  def switch(piece)
    piece == 'X' ? 'O' : 'X'
  end

  def the_best_move(scores)
    if piece == 'O'
      scores.max_by { |_k, v| v}
    else
      scores.min_by { |_k, v| v}
    end
    return scores[0]
  end


  

  def position_priority(board, mark)
    positions_with_values = board.positions_with_values
    Board::WINNING_PLACES.each do |winning_place|
      priority_positions_order = [[0, 1, 2], [0, 2, 1], [1, 2, 0]] 
       priority_positions_order.each do |priority|
        if (positions_with_values["#{winning_place[priority[0]]}"] == mark) and (positions_with_values["#{winning_place[priority[1]]}"] == mark)
          if positions_with_values["#{winning_place[priority[2]]}"] == " "
            return winning_place[priority[2]]
          end
        end
      end      
    end
    return nil
  end

end
