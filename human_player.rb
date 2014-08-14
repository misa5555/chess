class HumanPlayer
  attr_reader :name, :color
  
  def initialize(board, name, color)
    @board = board
    @name = name
    @color = color
  end
  
  def play_turn
    puts "It's #{@name}'s turn"
    move = gets.chomp
    
    if move == "CL" || move == "CR"
      direction = move
      @board.castling(self.color, direction)
    else
      direction = move
      start_pos, end_pos = move.split(",").map{|pos| convert_notation(pos)}
      @board.move(start_pos, end_pos, self.color)
    end
  end
  
  private
  def convert_notation position
    index1 = position[0].ord - "a".ord
    index2 = 8 - Integer(position[1])
    [index2, index1]
  end
end