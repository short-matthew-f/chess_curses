class Board
  attr_reader :pieces_captured, :grid
  
  def self.squares
    (0..7).map do |i|
      (0..7).map do |j|
        [i, j]
      end
    end.flatten(1)
  end
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @pieces_captured = []
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
    piece.pos = pos unless piece.nil?
  end
  
  def occupied?(pos)
    self[pos] != nil
  end
  
  def move_valid?(target_pos, piece)
    piece.moves.include?(target_pos)
  end
  
  def move_to(target_pos, piece)
    if move_valid?(target_pos, piece)
      
      @pieces_captured << self[target_pos] if occupied?(target_pos)
    
      self[piece.pos] = nil
      self[target_pos] = piece
    else
      raise ChessErrors::InvalidMoveError.new(target_pos, piece)
    end
    self
  end
  
  def pieces(color)
    @grid
      .flatten
      .compact
      .select { |piece| piece.color == color }
  end
  
  def to_s
    letters = ('A'..'H').to_a
    @grid.each_with_index.map do |row, r_index|
      "#{8-r_index} " + 
      row.each_with_index.map do |square, c_index|
        color = ((r_index+c_index) % 2 == 0) ? :light_white : :light_black
        square.nil? ? "   ".colorize(background: color) : " #{square} ".colorize(background: color)
      end.join
    end.join("\n") + "\n  " + letters.map { |let| " #{let} "}.join
  end
  
  def dup
    Board.new.tap do |board|
      (pieces(:white) + pieces(:black)).each do |piece|
        piece.class.new(piece.pos,piece.color,board)    
      end
    end 
  end
  
  def populate
    piece_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    
    piece_classes.each_with_index do |piece, col|
      piece.new([0, col], :black, self)
      piece.new([7, col], :white, self)
    end

    (0..7).map do |col|
      Pawn.new([1, col], :black, self)
      Pawn.new([6, col], :white, self)
    end
  end  
end