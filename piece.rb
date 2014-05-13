class Piece
  attr_accessor :pos, :color 
  attr_reader :board
  
  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def is_empty?(pos)
    board[pos]
  end
  
  def holds_enemy?(pos)
    !is_empty?(pos) && board[pos].color != self.color 
  end

end

class SteppingPiece < Piece
  def initialize(pos, color, board)
    super(pos, color, board)
  end
  
  def moves
    # returns an array of positions that are valid for this piece
    result = []
    
    Board.squares.each do |pos|
      result << pos if holds_enemy?(pos) || is_empty?(pos)
    end
  end
end

class Knight < SteppingPiece
  DELTAS = [
    [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2]
  ]
  
  
end

class King < SteppingPiece
  DELTAS = [
    [0, 1], [1, 1], [1, 0], [1, -1],
    [0, -1] [-1, -1], [-1, 0], [-1, 1]
  ]
end

class SlidingPiece < Piece
  def initialize(pos, color, board)
    super(pos, color, board)
  end
  
  
end

class Queen < SlidingPiece
  DELTAS = [
    [0, 1], [1, 1], [1, 0], [1, -1],
    [0, -1] [-1, -1], [-1, 0], [-1, 1]
  ]  
end

class Rook < SlidingPiece
  DELTAS = [
    [0, 1], [1, 0],
    [0, -1], [-1, 0]
  ]  
end

class Bishop < SlidingPiece
  DELTAS = [
    [1, 1], [1, -1],
    [-1, -1], [-1, 1]
  ]  
end

class Pawn < Piece
  def initialize(args)
    
  end
    
end