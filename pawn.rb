# encoding: utf-8

class Pawn < Piece
  def initialize color, position, board
    super
    @counter = 0
  end
  
  def moves
    direction = color == :white ? -1 : 1
    # direction = -1 if color == :white
    possible_moves = []
    one_forward = [position[0] + 1 * direction, position[1]]
    return [] unless within_boundary(one_forward)
    check_piece = @board[one_forward]
    if check_piece.nil?
      possible_moves << one_forward
      two_forward = [position[0] + 2 * direction, position[1]]
      if @counter == 0 && within_boundary(two_forward)
        check_piece2 = @board[two_forward]
        possible_moves << two_forward if check_piece2.nil?
      end
    end
    [1, -1].each do |horizontal_offset|
      diagonal = [position[0] + 1 * direction, position[1] + horizontal_offset]
      check_diagonal = @board[diagonal]
      if !check_diagonal.nil? && check_diagonal.color != @color
        possible_moves << diagonal
      end
    end
    possible_moves
  end
  
  def move position
    @position = position
    @counter += 1
  end
  
  def draw
    return "♙" if self.color == :white
    "♟"
  end
end