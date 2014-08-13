# encoding: utf-8

class Rook < SlidingPiece
  def move_dirs
    [[1, 0], [0,1], [-1, 0], [0, -1]]
  end
  
  def draw
    return "♖" if self.color == :white
    "♜"
  end
end