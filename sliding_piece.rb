class SlidingPiece < Piece
  # use @position
  
  # HORIZ_DIRS = []
#   DIAG_DIRS =[]
#


def moves
  possible_moves = []
  move_dirs.each do |dir|
    i = 1
    while true
      current_position = [@position[0] + dir[0] * i, @position[1] + dir[1] * i]
      break unless within_boundary(current_position)
      check_piece = @board[current_position]
      if check_piece.nil?
        possible_moves << current_position
      elsif check_piece.color != self.color
        possible_moves << current_position
        break
      else #hit friendly piece
        break
      end
      i += 1
    end    
  end
  possible_moves
  end
end