class Piece
  attr_reader :color, :position, :board
  def initialize color, position, board
    @color = color
    @position = position
    @board = board
  end
  # return an array of places piece can move to
  # implement in subclases
  def moves
  end
  
  def move position
    @position = position
  end
  
  def draw
  end
  
  def valid_moves
    moves.select do |check_move|
      !move_into_check?(check_move)
    end
  end
  
  def dup(new_board)
    self.class.new(@color, @position, new_board)
  end
  
  def within_boundary(pos)
    return true if pos.all? { |idx| idx.between?(0, 7) }
    false
  end
  
  private
  def move_into_check?(pos)
    #duplicate board to perform move
    #look to see in player is in check
    dup_board = @board.dup
    dup_board.move!(@position, pos)
    dup_board.in_check?(@color)
  end
end