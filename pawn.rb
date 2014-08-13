# encoding: utf-8

class Pawn < Piece
  def initialize color, position, board
    super
    @direction = color == :white ? -1 : 1
    @counter = 0
  end
  
  def moves
    one_forward = [position[0] + 1 * @direction, position[1]]
    return [] unless within_boundary(one_forward)
    get_forward_moves + get_diagonal_moves
  end
  
  def move position
    @position = position
    @counter += 1
  end
  
  def draw
    return "♙" if self.color == :white
    "♟"
  end
  
  private 
  def get_forward_moves
    results = []
    one_forward = [position[0] + 1 * @direction, position[1]]
    check_piece = @board[one_forward]
    if check_piece.nil?
      results << one_forward
      two_forward = [position[0] + 2 * @direction, position[1]]
      if @counter == 0 && within_boundary(two_forward)
        check_piece2 = @board[two_forward]
        results << two_forward if check_piece2.nil?
      end
    end
    results
  end
  
  def get_diagonal_moves
    results = []
    [1, -1].each do |horizontal_offset|
      diagonal = [position[0] + 1 * @direction, position[1] + horizontal_offset]
      check_diagonal = @board[diagonal]
      if !check_diagonal.nil? && check_diagonal.color != @color
        results << diagonal
      end
    end
    results
  end
end