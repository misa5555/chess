# encoding: utf-8

class Bishop < SlidingPiece
  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
  
  def draw
    return "♗" if self.color == :white
    "♝"
  end
end