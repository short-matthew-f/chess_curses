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
    until checkmate?(current_player)
      
      system "clear"
      puts self.board
      puts "DANGER" if board.in_check?(current_player)
      begin
        puts "#{current_player.capitalize}'s move.  Enter move (e.g. E2-E4)."
        source, target = parse_input(gets.chomp)
        if board[source].color == current_player
          raise "THAT WILL KILL YOU" if check_next_move(source, target)
          
          move(source, target)
        else
          raise "That's not your piece."
        end
      rescue StandardError => e
        puts e.message
        retry
      end
      
      current_player = (current_player == :white ? :black : :white)      
    end
  end
  
  def checkmate?(color)
    lose_game = true
    my_friends = @board.pieces(color)
    my_friends.each do |friend|
      their_moves = friend.moves
      their_moves.each do |target|
        lose_game = false unless check_next_move(friend.pos, target)
      end  
    end
    lose_game
  end
  
  def check_next_move(source, target)
    b = @board.dup
    b.move_to(target, b[source])
    b.in_check?(b[target].color)
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