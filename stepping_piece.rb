class SteppingPiece < Piece
  def moves
    possible_moves = []
    move_offsets.each do |step|
      check_position = [@position[0] + step[0], @position[1] + step[1]]
      next unless within_boundary(check_position)
      check_piece = @board[[check_position[0], check_position[1]]]
      if check_piece.nil? || check_piece.color != self.color
        possible_moves << check_position  
      end
    end
    possible_moves    
  end
end