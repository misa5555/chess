# encoding: utf-8

class Queen < SlidingPiece
  # SlidingPiece#moves will use
  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [0,1], [-1, 0], [0, -1]]
    #HORIZ + DIAG
  end

  def draw
    return "♕" if self.color == :white
    "♛"
  end
end