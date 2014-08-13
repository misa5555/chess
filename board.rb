
class Board
  LENGTH = 8
  attr_accessor :test, :grids
  
  def self.generate_test_board(test_positions)
    b = Board.new(false)
    test_positions.each do |piece, pos, color|
      b.set_piece(piece, pos, color)
    end
    b
  end
  
  def initialize(default_board = true)
    @grids = Array.new(LENGTH){ Array.new(LENGTH, nil) }
    generate_initial_board if default_board
  end  
  
  def set_piece(piece, pos, color)
    @grids[pos[0]][pos[1]] = piece.new(color, pos, self)
  end
  
  # in outer class: @board = Board.new()
  # piece = @board[x,y]
  def [](pos)
    x, y = pos
    @grids[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @grids[x][y] = piece
  end    
  
  def render
    base = "   a b c d e f g h"
    puts base
    puts "-" * base.length
     #
    # puts @grids.map do |row|
    #   row.map do |piece|
    #     piece.draw unless piece.nil?
    #     " "
    #   end.join(" ")
    # end.join("\n")
    @grids.each_with_index do |row, i|
      next_line = (8-i).to_s+"| "
      row.each do |piece|
        if piece.nil?
          next_line << " "
        else
          next_line << piece.draw
        end
        next_line << " "
      end
      puts next_line
    end
  end
  
  # returns boolean
  def in_check?(color)
    king = find_king(color)
    king_pos = king.position
    find_color_pieces(opposite_color(color)).each do |piece|
      return true if piece.moves.include?(king_pos)
    end
    return false
  end
  
  def move(start, end_pos)
    raise NoPieceAtThisLocationError.new("No piece at #{ start.to_s }") if self[start].nil?
    raise InvalidMoveError.new("Invalid move") unless self[start].moves.include?(end_pos)
    raise MoveIntoCheckError.new("Moving into check") unless self[start].valid_moves.include?(end_pos)
    self.move!(start, end_pos)
  end
  
  def move!(start, end_pos)
    raise NoPieceAtThisLocationError.new("No piece at #{ start.to_s }") if self[start].nil?
    piece_to_move = self[start]
    if piece_to_move.moves.include?(end_pos)
      piece_to_move.move(end_pos)
      self[start] = nil
      self[end_pos] = piece_to_move
    else
      raise "Cannot move piece there"
    end
  end
  
  def dup
    copy_board = Board.new(false)
    
    @grids.flatten.compact.each do |piece|
      copy_board[piece.position] = piece.dup(copy_board)
    end
    
    # @grids.each_with_index do |row, i|
    #   row.each_with_index do |piece, j|
    #     unless piece.nil?
    #       copy_board.grids[i][j] = piece.dup(copy_board)
    #     end
    #   end
    # end
    copy_board
  end
  
  def checkmate?(color)
    return false unless in_check?(color)
    find_color_pieces(color).each do |piece|
      return false if !piece.valid_moves.empty?
    end
    true
  end
  
private  
  def generate_initial_board
    piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    piece_order.each_with_index do |piece, y|
      # @grids[0][y] = piece.new(:black, [0, y], self)
      self[[0, y]] = piece.new(:black, [0, y], self)
      self[[7, y]] = piece.new(:white, [7, y], self)
    end
    
    #pawn
    8.times do |i|
      @grids[1][i] = Pawn.new(:black, [1, i], self)
      @grids[6][i] = Pawn.new(:white, [6, i], self)
    end  
  end
  
  def find_king(color)
    find_color_pieces(color).find { |piece| piece.is_a?(King) }
  end
  
  def find_color_pieces(color)
    @grids.flatten.compact.select { |piece| piece.color == color }
  end
  
  def opposite_color(color)
    color == :white ? :black : :white
  end
end