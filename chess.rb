require "./chess_errors.rb"
require "./piece.rb"
require "./board.rb"
require 'debugger'
require 'colorize'
require 'yaml'

class Chess
  attr_accessor :board, :players
  
  # include ChessErrors
  
  def initialize
    if load_prompt
      @board = YAML::load_file('save_game.txt')
    else  
      @board = Board.new
      @board.populate
    end
    
    @players = [:black, :white]
  end
  
  def play
    until checkmate?
      render_board
      print_check_message if in_check?
      prompt_user
      switch_player
    end
    
    print_win_message
  end
  
  
  protected
  
  def switch_player
    player = @players.shift
    @players << player
  end
  
  def current_player
    players.last
  end
  
  def next_player
    players.first
  end
  
  def load_prompt
    puts "Would you like to load a game? (y/n)"
    input = gets.chomp.downcase
    input == 'y'
  end
  
  def print_captured
    white_cap = board
      .pieces_captured
      .select { |p| p.color == :white }
      .join
      .ljust(12)
      .colorize(background: :light_white)
      
    black_cap = board
      .pieces_captured
      .select { |p| p.color == :black }
      .join
      .rjust(12)
      .colorize(background: :light_white) 
      
    "  #{white_cap}#{black_cap}"    
  end
  
  def print_win_message
    render_board
    puts "Checkmate!  #{next_player.capitalize} has won."
  end
  
  def print_check_message
    puts "#{current_player.capitalize} is in check."
  end
  
  def render_board
    system "clear"
    puts "\n\n"
    puts board
    puts print_captured
  end
  
  def prompt_user
    begin
      puts "#{current_player.capitalize}'s move.  Enter move (e.g. E2-E4) or (s)ave/(q)uit."
      print "> "
      input = gets.chomp
      if input == 's'
        File.open('save_game.txt', 'w') { |f| f.write board.to_yaml }
        raise ChessErrors::GameSaveError
      elsif input == 'q'
        puts "Goodbye"
        abort
      else
        source, target = parse_input(input)
        if board[source].color == current_player
          raise ChessErrors::PutsInCheckError if check_next_move(source, target)
          move(source, target)
        else
          raise ChessErrors::NotYourPieceError
        end
      end
    rescue StandardError => e
      puts e.message
      retry
    end
  end
  
  def in_check?(player = self.current_player, board = @board)
    king = board.pieces(player).select { |p| p.is_a?(King) }[0]
    enemy = (player == :white ? :black : :white)
    
    board.pieces(enemy).any? do |piece|
      piece.attackable_positions.include?(king.pos)
    end
  end
  
  def checkmate?
    return false unless in_check?
    lose_game = true
    my_friends = board.pieces(current_player)
    my_friends.each do |friend|
      their_moves = friend.moves
      their_moves.each do |target|
        lose_game = false unless check_next_move(friend.pos, target)
      end  
    end
    lose_game
  end
  
  def check_next_move(source, target)
    b = board.dup
    b.move_to(target, b[source])
    in_check?(b[target].color, b)
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