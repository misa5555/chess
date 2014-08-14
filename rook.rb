# encoding: utf-8

class Rook < SlidingPiece
  attr_reader :counter
  def initialize(color, position, board)
    super
    @counter = 0
  end
  
  def move_dirs
    [[1, 0], [0,1], [-1, 0], [0, -1]]
  end
  
  def move position
    @position = position
    @counter += 1
  end
  
  def draw
    return "♖" if self.color == :white
    "♜"
  end
end