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
    result
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

  def moves
    result = []
    
    self.class::DELTAS.each do |delta|
      current_pos = [self.pos[0]+delta[0], self.pos[1]+delta[1]]
      while Board.squares.include?(current_pos) &&
        (is_empty?(current_pos) || holds_enemy?(current_pos))
        
        result << current_pos 
        
        break if holds_enemy?(current_pos)
        
        current_pos = [current_pos[0]+delta[0], current_pos[1]+delta[1]]
      end
    end
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