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

    position = check_priority(board)

    board.positions_with_values["#{position}"] = "O"

    check_end(board,engine)

    board.display
  end

  private

  def check_priority(board) # artificial intelligence logic comes here
    flag = true

    x_mark = "X"
    o_mark = "O"

    o_position = position_priority(board, o_mark) # O's position should check first.

    if !o_position.nil?
      return o_position
    end

    x_position = position_priority(board, x_mark)

    if !x_position.nil?
      return x_position

    while flag do
      random_position = 1 + rand(8)
       positions_with_values = board.positions_with_values["#{random_position}"]
      if positions_with_values != "X" and positions_with_values != "O"
        positions_with_values = "O"
        return random_position
        flag false
      end
    end
  end

  

  end

  def position_priority(board, mark)
    Board::WINNING_PLACES.each do |winning_place|
      priority_positions_order = [[0, 1, 2], [0, 2, 1], [1, 2, 0]]
      positions_with_values = board.positions_with_values
       priority_positions_order.each do |priority|
        if (positions_with_values["#{winning_place[priority[0]]}"] == mark) and (positions_with_values["#{winning_place[priority[1]]}"] == mark)
          if positions_with_values["#{winning_place[priority[2]]}"] == " "
            return winning_place[priority[2]]
          end
        end
      end      
      #winner_position(winning_place,board,mark,priority_positions_order)
    end
    return nil
  end


end
