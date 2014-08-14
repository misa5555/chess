# encoding: utf-8

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
    
    @grids.each_with_index do |row, i|
      next_line = (8-i).to_s+"| "
      row.each_with_index do |piece, j|
        if (i + j).odd?
          colorize_options = { :background => :light_black }
        else
          colorize_options = { :background => :white }
        end
        if piece.nil?
          next_line << "  ".colorize(colorize_options)
        else
          next_line << (piece.draw + " ").colorize(colorize_options).bold
        end
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
  
  def move(start, end_pos, color)
    raise NoPieceAtThisLocationError.new("No piece at #{ start.to_s }") if self[start].nil?
    raise InvalidMoveError.new("Invalid move") unless self[start].moves.include?(end_pos)
    raise MoveIntoCheckError.new("Moving into check") unless self[start].valid_moves.include?(end_pos)
    raise WrongColorPieceError.new("wrong color piece") unless self[start].color == color
    self.move!(start, end_pos)
  end
  
  def move!(start, end_pos)
    raise NoPieceAtThisLocationError.new("No piece at #{ start.to_s }") if self[start].nil?
    piece_to_move = self[start]
    piece_to_move.move(end_pos)
    self[start] = nil
    self[end_pos] = piece_to_move
  end
  
  def dup
    copy_board = Board.new(false)
    @grids.flatten.compact.each do |piece|
      copy_board[piece.position] = piece.dup(copy_board)
    end
    copy_board
  end
  
  def checkmate?(color)
    return false unless in_check?(color)
    find_color_pieces(color).each do |piece|
      return false if !piece.valid_moves.empty?
    end
    true
  end
  
  def castling(color, direction)
    # conditions
    # if passed conditions
    king = find_king(color)
    rook = find_rook_castling(king, direction) # rook is nil if not found 
    raise CanNotCastlingError.new("can not do castling") unless castling?(king, rook)    
    raise NoRookForCastlingError.new("no rook for casting") if rook.nil?
    vector = (rook.position[1] - king.position[1] > 0) ? 1 : -1
    king_new_position = king.position[0], king.position[1] + vector * 2
    rook_new_position = king.position[0], king.position[1] + vector 
    move!(king.position, king_new_position)
    move!(rook.position, rook_new_position)
  end
  
  def tie?
    return true if stalemate?(:white) || stalemate?(:black)
    false
  end
  
  # returns how many times same board exists in history
  def past_frequency(history)
    count = 0
    history.each do |past_board|
      count += 1 if compare_board(self, past_board)
    end
    count  
  end
  
  def promote_pawn(color)
    pawn_at_goal = pawn_at_eighth_rank(color)
    unless pawn_at_goal.nil?
      puts "change pawn into what? "
      change_into = gets.chomp
      change_pawn(pawn_at_goal, change_into)
    end        
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
  
  #returns boolean
  def castling?(king, rook)
    if king.color == :black
      return false if king.position[0] != 0 || rook.position[0] != 0
    elsif king.color == :white
      return false if king.position[0] != 7 || rook.position[0] != 7
    end
    vector = (rook.position[1] - king.position[1] > 0) ? 1 : -1
    return false if king.counter != 0 || rook.counter != 0
    color = king.color
    between_idx = between(king.position[1], rook.position[1])
    between_idx.each do |idx|
      return false unless @grids[king.position[0]][idx] == nil
    end
    return false if in_check?(king.color) 
    
    enemy_color = opposite_color(color)
    find_color_pieces(enemy_color).each do |piece|
      return false if piece.moves.include?([king.position[0], king.position[1] + 1 * vector])
      return false if piece.moves.include?([king.position[0], king.position[1] + 2 * vector])
    end
  end 
   
  def find_king(color)
    find_color_pieces(color).find { |piece| piece.is_a?(King) }
  end
  
  # returns array
  def find_rooks(color)
    find_color_pieces(color).select { |piece| piece.is_a?(Rook) }
  end
  
  # returns array
  def find_pawns(color)
    find_color_pieces(color).select { |piece| piece.is_a?(Pawn) }
  end
    
  def find_rook_castling(king, direction)
    color = king.color
    rooks = find_rooks(color)
    rook = nil
    if (color == :black && direction == "CL") || (color == :white && direction == "CR")
      rook = rooks.find { |rook| rook.position[1] > king.position[1] }
    else
      rook = rooks.find { |rook| rook.position[1] < king.position[1] }
    end
    rook          
  end 
  
  def between(a, b)
    if a < b
      return (a+1..b-1).to_a
    elsif a > b
      return (b+1..a-1).to_a
    else
      return []
    end  
  end
  
  def find_color_pieces(color)
    @grids.flatten.compact.select { |piece| piece.color == color }
  end
  
  def opposite_color(color)
    color == :white ? :black : :white
  end
  
  def stalemate?(color)
    condition1 = !in_check?(color)
    condition2 = find_color_pieces(color).all?{ |piece| piece.valid_moves.empty? }
    true if condition1 && condition2
  end
  
  # check if two board's values are the same
  def compare_board(board1, board2)
    b1 = board1.grids.flatten
    b2 = board2.grids.flatten
    b1.each_with_index do |grid1, i|
      return false unless compare_grid(b1[i], b2[i])
    end
    return true
  end
  
  def compare_grid(g1, g2)
    # both are nil
    return true if g1.nil? && g2.nil?
    # only the other is nil
    return false if (g1.nil? && !g2.nil?) || (!g1.nil? && g2.nil?)
    
    # both are pieces
    if g1.class == g2.class && g1.color == g2.color
      # class, color are the same(except for positions)
      return true
    else
      # some values are different
      return false
    end  
  end
  
  def change_pawn(pawn, change_into)
    case change_into
      when "Q"
        new_piece = Queen.new(pawn.color, pawn.position, self)
      when "K"
        new_piece = Knight.new(pawn.color, pawn.position, self)
      when "R"
        new_piece = Rook.new(pawn.color, pawn.position, self)
      when "B"
        new_piece = Bishop.new(pawn.color, pawn.position, self)
      else
        raise InvalidInputError.new("Input Q/R/B/K")
        return
    end
    self[pawn.position] = new_piece            
  end
  
  # returns pawn 
  def pawn_at_eighth_rank(color)
    pawns = find_pawns(color)
    goal_line = (color == :white) ? 0 : 7
    pawns.find { |pawn| pawn.position[0] == goal_line }
  end 
end