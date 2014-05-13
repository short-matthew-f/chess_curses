class Board
  def self.squares
    #[[0,0], [0,1]]
    (0..7).map do |i|
      (0..7).map do |j|
        [i, j]
      end
    end.flatten(1)
  end
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @pieces_captured = []
    populate
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
  
  # board.move_to([3,5], pawn)
  def move_to(target_pos, piece)
    if move_value?(target_pos, piece)
      # if the target is occupied, capture it
      @pieces_captured << self[target_pos] if occupied?(target_pos)
    
      # set where we're coming from to nil, it's now empty
      self[piece.pos] = nil
      self[target_pos] = piece
    else
      raise "Your #{piece.class} at #{piece.pos} cannot move to #{target_pos}"
    end
  end
  
  def pieces(color)
    @grid
      .flatten
      .compact
      .select {|piece| piece.color == color}
  end
  
  def to_s
    letters = ('A'..'H').to_a
    @grid.each_with_index.map do |row, index|
      "#{8-index} " + 
      row.map do |square|
        square.nil? ? "[ ]" : "[#{square}]"
      end.join
    end.join("\n") + "\n  " + letters.map { |let| " #{let} "}.join
  end
  
  def in_check?(color)
    king_pos = pieces(color).select{ |p| p.is_a?(King) }[0].pos
    enemy_color = (color == :white ? :black : :white)
    pieces(enemy_color).any? do |piece|
      piece.moves.include?(king_pos)
    end
  end
  
  def populate
    (0..7).map do |col|
      Pawn.new([1, col], :black, self)
      Pawn.new([6, col], :white, self)
    end
    [0, 7].map do |col|
      Rook.new([0, col], :black, self)
      Rook.new([7, col], :white, self)
    end
    [1, 6].map do |col|
      Knight.new([0, col], :black, self)
      Knight.new([7, col], :white, self)
    end
    [2, 5].map do |col|
      Bishop.new([0, col], :black, self)
      Bishop.new([7, col], :white, self)
    end    
    Queen.new([0, 3], :black, self)
    Queen.new([7, 3], :white, self)
    King.new([0, 4], :black, self)
    King.new([7, 4], :white, self)
  end
  
end