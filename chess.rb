require "./piece.rb"
require "./board.rb"
require 'debugger'

class Chess
  attr_accessor :board
  
  def initialize
    @board = Board.new
    @board.populate
  end
  
  def play
    current_player = :white
    loop do
      system "clear"
      puts self.board
      begin
        puts "#{current_player.capitalize}'s move.  Enter move (e.g. E2-E4)."
        source, target = parse_input(gets.chomp)
        if board[source].color == current_player
          move(source, target)
        else
          raise "That's not your piece."
        end
      rescue StandardError => e
        puts e.message
        retry
      end
      
      current_player = (current_player == :white ? :black : :white)
      # break if @board.dup.checkmate?(current_player)
    end
  end
  
  def move(source, target)
    board.move_to(target, board[source])
  end
  
  # "E2-A4"
  def parse_input(string)
    string.split('-').map(&:upcase).map { |s| to_pos(s) }
  end
  
  def to_pos(string)
    letters = ('A'..'H').to_a
    [8-string[1].to_i, letters.index(string[0])]
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  game.play
end