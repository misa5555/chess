# encoding: utf-8

class King < SteppingPiece
  def move_offsets
    [[1, 0], 
    [1, 1], 
    [0, 1], 
    [-1, 1], 
    [-1, 0], 
    [-1, -1], 
    [0, -1], 
    [1, -1]]
  end
  
  def draw
    return "♔" if self.color == :white
    "♚"
  end
end