require 'curses'
require 'colorize'
require 'yaml'
require './board.rb'
require './piece.rb'

include Curses

class GameRender
  attr_reader :window, :board, :board_colors
  
  def initialize
    init_screen
    noecho
    cbreak
    
    @board = YAML::load_file('save_game.txt')
    @board_colors = set_initial_attributes
    @window = Window.new(0, 0, 0, 0)
    @window.keypad(true)
    
    start_color
    initialize_colors
    @window.bkgd(1)
  end
  
  def set_initial_attributes
    h = Hash.new 
    (0..7).each do |i|
      (0..7).each do |j|
        h[[i,j]] = { 
          select: false,
          highlight: false
        }
      end
    end
    h
  end
  
  def color_at(pos)
    if board_colors[pos][:select]
      select_color_at(pos)
    elsif board_colors[pos][:highlight]
      highlight_color_at(pos)
    else
      initial_color_at(pos)
    end
  end
  
  def initial_color_at(pos)
    i, j = pos
    (i+j) % 2 == 0 ? color_pair(1) : color_pair(2)
  end
  
  def highlight_color_at(pos)
    i, j = pos
    (i+j) % 2 == 0 ? color_pair(3) : color_pair(4)
  end
  
  def select_color_at(pos)
    i, j = pos
    (i+j) % 2 == 0 ? color_pair(5) : color_pair(6)
  end
  
  def initialize_colors
    init_pair(1, COLOR_BLACK, COLOR_WHITE)
    init_pair(2, COLOR_WHITE, COLOR_BLACK)
    init_pair(3, COLOR_BLACK, COLOR_YELLOW)
    init_pair(4, COLOR_WHITE, COLOR_YELLOW)
    init_pair(5, COLOR_RED, COLOR_WHITE)
    init_pair(6, COLOR_RED, COLOR_BLACK)    
  end
  
  def draw_board_tiles
    (0..7).each do |i|
      (0..7).each do |j|
        window.attron(color_at([i,j])|A_NORMAL)
        fill_square([i,j])
      end
    end    
  end
  
  def add_pieces_to_board
    board.grid.flatten.compact.each do |piece|
      x, y = grid_to_board(piece.pos)
      window.setpos(x, y)
      if (piece.pos[0] + piece.pos[1]) % 2 == 0
        window.attron(color_at(piece.pos)|A_NORMAL)
      else
        window.attron(color_at(piece.pos)|A_NORMAL)
      end
      window.addstr("#{piece}")
    end
  end
  
  def draw_board(board)
    draw_board_tiles
    add_pieces_to_board
   
    x, y = 0, 0
    
    loop do 
      current_x, current_y = grid_to_board([x,y])
      
      draw_board_tiles
      add_pieces_to_board
      
      window.refresh
      window.setpos(current_x, current_y)
      
      chr = window.getch
      
      case chr
      when Curses::Key::UP
        x -= 1 unless x <= 0
      when Curses::Key::DOWN
        x += 1 unless x >= 7
      when Curses::Key::LEFT
        y -= 1 unless y <= 0
      when Curses::Key::RIGHT
        y += 1 unless y >= 7  
      when " "
        highlight([x,y])
      when "s"
        select([x,y])
      end
    end
  end
  
  def highlight(pos)
    @board_colors[pos][:highlight] = !@board_colors[pos][:highlight]
  end
  
  def select(pos)
    @board_colors[pos][:select] = !@board_colors[pos][:select]
  end
  
  # grid_to_board([0,0]) => [1,2] && grid_to_board([1,1]) => [3,6] 
  def grid_to_board(pos)
    row, col = pos
    [row + 1, 3 * col + 2 ]
  end
  
  def fill_square(pos)
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