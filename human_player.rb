class HumanPlayer
  attr_reader :name
  def initialize(board, name)
    @board = board
    @name = name
  end  
  def play_turn
    puts "It's #{@name}'s turn"
    move = gets.chomp

    start_pos, end_pos = move.split(",").map{|pos| convert_notation(pos)}
    @board.move(start_pos, end_pos)    
  end
  
  def convert_notation position
    index1 = position[0].ord - "a".ord
    index2 = 8 - Integer(position[1])
    [index2, index1]
  end
end