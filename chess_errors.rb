module ChessErrors
  class GameSaveError < StandardError
    def message
      "Thank you for saving your game."
    end
  end
  
  class NotYourPieceError < StandardError
    def message
      "That's not your piece!"
    end    
  end
  
  class PutsInCheckError < StandardError
    def message
      "That move would put you in check!"
    end    
  end
  
  class BadInputError < StandardError
    def message
      "Your input is bad, and you should feel bad."
    end
  end
  
  class InvalidMoveError < StandardError
    def initialize(target_pos, piece)
      @target_pos, @piece = target_pos, piece
    end
    
    def message
      "Your #{@piece.class.to_s.downcase} at #{Piece.un_pos(@piece.pos)} cannot move to #{Piece.un_pos(@target_pos)}"
    end
  end
end