require 'curses'
require 'colorize'
require 'yaml'
require './board.rb'
require './piece.rb'

include Curses

class GameRender
  attr_reader :window, :board, :board_attributes, :cursor_position
  
  def initialize(board = nil)
    @board = board || YAML::load_file('save_game.txt')
    @board_attributes = set_initial_attributes
    @cursor_position = [0, 0]
    initialize_window  
  end
  
  def initialize_colors
    # colors for the board
    init_pair(1, COLOR_BLACK, COLOR_WHITE)
    init_pair(2, COLOR_WHITE, COLOR_BLACK)
    # colors for when a square is highlighted
    init_pair(3, COLOR_BLACK, COLOR_YELLOW)
    init_pair(4, COLOR_WHITE, COLOR_YELLOW)
    # colors for when a piece has been picked
    init_pair(5, COLOR_RED, COLOR_WHITE)
    init_pair(6, COLOR_RED, COLOR_BLACK)    
  end
  
  def draw_board
    draw_board_tiles
    draw_pieces_on_board
  end

  def wait_for_source
    loop do 
      i, j = cursor_position
      x, y = pos_to_coord([i,j])
      
      window.refresh
      window.setpos(x, y)
      
      chr = window.getch
      
      case chr
      when Curses::Key::UP
        i -= 1 unless i <= 0
      when Curses::Key::DOWN
        i += 1 unless i >= 7
      when Curses::Key::LEFT
        j -= 1 unless j <= 0
      when Curses::Key::RIGHT
        j += 1 unless j >= 7  
      when " "
        @cursor_position = [i,j]
        return( :select_piece )
      when "s" || "S"
        @cursor_position = [i,j]
        return( :save_game )
      when "q" || "Q"
        return( :quit_game )
      end
      @cursor_position = [i,j]
    end
  end

  def wait_for_target
    loop do 
      i, j = cursor_position
      x, y = pos_to_coord([i,j])

      window.refresh
      window.setpos(x, y)
      
      chr = window.getch
      
      case chr
      when Curses::Key::UP
        i -= 1 unless i <= 0
      when Curses::Key::DOWN
        i += 1 unless i >= 7
      when Curses::Key::LEFT
        j -= 1 unless j <= 0
      when Curses::Key::RIGHT
        j += 1 unless j >= 7  
      when " "
        @cursor_position = [i,j]
        return( cursor_position )
      end
      @cursor_position = [i,j]
    end
  end

  def send_message(message)
    clear_message 

    i, j = cursor_position
    window.setpos(10, 2)
    window.addstr(message)
    window.setpos(i, j)

    nil
  end

  def clear_message
    i, j = cursor_position
    window.setpos(10, 2)
    window.addstr(" ".ljust(50))
    window.setpos(i, j)

    nil
  end

  def highlight(pos)
    @board_attributes[pos][:highlight] = !@board_attributes[pos][:highlight]
  end
  
  def select(pos)
    @board_attributes[pos][:select] = !@board_attributes[pos][:select]
  end

  protected

  def initialize_window
    init_screen
    @window = Window.new(0, 0, 0, 0)
    @window.keypad(true)
    noecho
    cbreak    
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
    if board_attributes[pos][:select]
      select_color_at(pos)
    elsif board_attributes[pos][:highlight]
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

  # pos_to_coord(pos) converts board position to render coordinates
  def pos_to_coord(pos)
    row, col = pos
    [row + 1, 3 * col + 2 ]
  end

  def fill_square(pos)
    x, y = pos_to_coord(pos)
    (-1..1).each do |i|
        window.setpos(x, y + i)
        window.addstr(" ")
    end
  end

  def draw_board_tiles
    (0..7).each do |i|
      (0..7).each do |j|
        window.attron(color_at([i,j])|A_NORMAL)
        fill_square([i,j])
      end
    end    
  end
  
  def draw_pieces_on_board
    board.grid.flatten.compact.each do |piece|
      x, y = pos_to_coord(piece.pos)
      window.setpos(x, y)
      if (piece.pos[0] + piece.pos[1]) % 2 == 0
        window.attron(color_at(piece.pos)|A_NORMAL)
      else
        window.attron(color_at(piece.pos)|A_NORMAL)
      end
      window.addstr("#{piece}")
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  gr = GameRender.new
  gr.draw_board
  gr.wait_for_input
end