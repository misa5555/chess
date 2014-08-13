
class Game
  def initialize(player1, player2, board)
    @board = board
    @player1 = player1
    @player2 = player2
  end
  
  def run
    moving_player = @player1
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @board.render
      begin
        moving_player.play_turn
      rescue InvalidInputError => e
        puts e.message
        puts 'Be sure to use this format: 1,2' 
        retry
      end    
      moving_player = toggle_player(moving_player)
    end
    @board.render
    loser = toggle_player(moving_player)
    puts "#{loser.name} is in Checkmate"
  end
  
  def toggle_player(moving_player)
    if moving_player == @player1
      next_player = @player2
    else
      next_player = @player1
    end
    next_player
  end
end