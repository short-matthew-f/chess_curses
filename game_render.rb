require 'curses'
require 'yaml'
require './board.rb'
require './piece.rb'

include Curses

class GameRender
BOARD = %Q{+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+
|   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+}
  
  def initialize
    @board = YAML::load_file('save_game.txt')
  end
  
  def draw_board(board)
    height, width= 19, 35
    window = Window.new(0, 0, 0, 0)
    window.addstr(BOARD)
    window.refresh
    @board.grid.flatten.compact.each do |piece|
      x, y = grid_to_board(piece.pos)
      window.setpos(x, y)
      window.addstr("#{piece}")
      sleep(0.1)
      window.refresh
    end
    window.getch
  end
  
  def go
    begin
      crmode
      setpos(4, 1)
      addstr("WELCOME TO CHESS, MOFO")
      refresh
      getch
      self.draw_board(@board)
      refresh
    ensure
      close_screen
    end
  end
  
  def puts_board
    print BOARD
  end
  
  # grid_to_board([0,0]) => [1,2] && grid_to_board([1,1]) => [3,6] 
  def grid_to_board(pos)
    row, col = pos
    [2 * row + 1, 4 * col + 2]
  end
  
  def fill_square(pos)
    
  end
end

if __FILE__ == $PROGRAM_NAME
  gr = GameRender.new
  gr.go
end