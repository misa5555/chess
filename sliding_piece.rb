class SlidingPiece < Piece
  # use @position
  
  # HORIZ_DIRS = []
#   DIAG_DIRS =[]
#


def moves
  possible_moves = []
  move_dirs.each do |dir|
    i = 1
    while true do
      current_position = [@position[0] + dir[0]*i, @position[1] + dir[1]*i]
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
  # def moves
  #   possible_moves = []
  #   move_dirs.each do |dir|
  #     current_position = @position
  #     possible_direction = true
  #     while possible_direction
  #       current_position = [current_position[0] + dir[0], current_position[1] + dir[1]]
  #       if current_position.all? { |pos| pos.between?(0, 7) }
  #         check_piece = @board[current_position]
  #         if check_piece.nil?
  #           possible_moves << current_position
  #         else
  #           if check_piece.color != self.color
  #             possible_moves << current_position
  #             possible_direction = false
  #           else #hit friendly piece
  #             possible_direction = false
  #           end
  #         end
  #       else
  #         possible_direction = false
  #       end
  #     end
  #   end
  #   possible_moves
  # end
end