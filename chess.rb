require "./piece.rb"
require "./board.rb"

require 'debugger'
require 'colorize'
require 'yaml'

class Chess
  attr_accessor :board
  
  def initialize
    if load_prompt
      @board = YAML::load_file('save_game.txt')
    else  
      @board = Board.new
      @board.populate
    end
  end
  
  def play
    current_player = :white
    until checkmate?(current_player)
      render_board(current_player)
      prompt_user(current_player)
      current_player = (current_player == :white ? :black : :white)      
    end
  end
  
  
  protected
  
  def load_prompt
    puts "Would you like to load a game? (y/n)"
    input = gets.chomp.downcase
    input == 'y'
  end
  
  def print_captured
    white_cap = @board
      .pieces_captured
      .select { |p| p.color == :white }
      .join
      .ljust(12)
      .colorize(background: :light_white)
    black_cap = @board
      .pieces_captured
      .select { |p| p.color == :black }
      .join
      .rjust(12)
      .colorize(background: :light_white) 
    "  #{white_cap}#{black_cap}"    
  end
  
  def render_board(current_player)
    system "clear"
    puts "\n\n"
    puts self.board
    puts print_captured
    puts "DANGER" if board.in_check?(current_player)
  end
  
  def prompt_user(current_player)
    begin
      puts "#{current_player.capitalize}'s move.  Enter move (e.g. E2-E4) or (s)ave/(q)uit."
      print "> "
      input = gets.chomp
      if input == 's'
        File.open('save_game.txt', 'w') { |f| f.write @board.to_yaml }
        raise "Thanks for saving the game."  
      elsif input == 'q'
        puts "Goodbye"
        abort
      else
        source, target = parse_input(input)
        if board[source].color == current_player
          raise "THAT WILL KILL YOU" if check_next_move(source, target)
          move(source, target)
        else
          raise "That's not your piece."
        end
      end
    rescue StandardError => e
      puts e.message
      retry
    end
  end
  
  def checkmate?(color)
    return false if !@board.in_check?(color)
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