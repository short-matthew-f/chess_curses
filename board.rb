class Board
  def self.squares
    #[[0,0], [0,1]]
    (0..7).map do |i|
      (0..7).map do |j|
        [i, j]
      end
    end.flatten(1)
  end
  
  def initialize(args)

  end
  
  def [](pos)
    
  end
  
end