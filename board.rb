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
  
end