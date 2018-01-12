#----------------------------------------------
# TicTacToe game in Ruby Language
# author: [Sanosh Wadghule, santosh.wadghule@gmail.com]
# copyright: (c) 2011 Santosh Wadghule
#----------------------------------------------

class Board

  attr_reader :info, :positions_with_values

  WINNING_PLACES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]


  def initialize # board position starts from 1 to 9
    @positions_with_values = {"1" => " ", "2" => " ", "3" => " ",
                              "4" => " ", "5" => " ", "6" => " ",
                              "7" => " ", "8" => " ", "9" => " "}
  end

  def display_positions # initial user friendly board display

    for index in 1..9
      puts "" if index==1
      print " #{index} "
      if index%3!=0
        print "\|"
      elsif index!=9
        print "\n-----------\n"
      end 
    end

    print "\n\n"

  end

  def display

    for index in 1..9
      puts "" if index==1
      print " #{self.positions_with_values[index.to_s]} "
      if index%3!=0
        print "\|"
      elsif index!=9
        print "\n-----------\n"
      end 
    end

    print "\n"


  end

end

