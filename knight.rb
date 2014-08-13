# encoding: utf-8

class Knight < SteppingPiece
  def move_offsets
    [[1, 2], 
    [1, -2], 
    [-1, 2], 
    [-1, -2], 
    [2, 1], 
    [2, -1], 
    [-2, 1], 
    [-2, -1]]
  end
  
  def draw
    return "♘" if self.color == :white
    "♞"
  end
end