require "./piece.rb"
require "./board.rb"

class Chess
  def initialize
    @board = Board.new
    puts @board
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
end