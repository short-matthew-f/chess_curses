require 'curses'
require 'colorize'
require 'yaml'
require './board.rb'
require './piece.rb'

include Curses

class GameRender
  attr_reader :window, :board
  
  def initialize
    @board = YAML::load_file('save_game.txt')
    @window = Window.new(0, 0, 0, 0)
    start_color
    initialize_colors
    @window.bkgd(1)
  end
  
  def initialize_colors
    init_pair(1, COLOR_WHITE, COLOR_WHITE)
    init_pair(2, COLOR_WHITE, COLOR_BLACK)
    init_pair(3, COLOR_BLACK, COLOR_WHITE)      
  end
  
  def draw_board_tiles
    (0..7).each do |i|
      (0..7).each do |j|
        if (i+j) % 2 == 0
          window.attron(color_pair(2)|A_NORMAL)
        else
          window.attron(color_pair(3)|A_NORMAL)
        end
        fill_square([i,j], window)
      end
    end    
  end
  
  def add_pieces_to_board
    board.grid.flatten.compact.each do |piece|
      x, y = grid_to_board(piece.pos)
      window.setpos(x, y)
      if (piece.pos[0] + piece.pos[1]) % 2 == 0
        window.attron(color_pair(2)|A_NORMAL)
      else
        window.attron(color_pair(3)|A_NORMAL)
      end
      window.addstr("#{piece}")
    end
  end
  
  def draw_board(board)
    draw_board_tiles
    add_pieces_to_board
    window.refresh

    current_x, current_y = grid_to_board([0,0])
    
    loop do 
    end
  end
  
  def puts_board
    print BOARD
  end
  
  # grid_to_board([0,0]) => [1,2] && grid_to_board([1,1]) => [3,6] 
  def grid_to_board(pos)
    row, col = pos
    [row + 3, 3 * col + 5]
  end
  
  def fill_square(pos, window)
    x, y = grid_to_board(pos)
    (-1..1).each do |i|
        window.setpos(x, y + i)
        window.addstr(" ")
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  gr = GameRender.new
  gr.draw_board(nil)
end