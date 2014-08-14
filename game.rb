
class Game
  def initialize(player1, player2, board)
    @board = board
    @player1 = player1
    @player2 = player2
    @history = []
  end
  
  def run
    moving_player = @player1
    until @board.checkmate?(:white) || @board.checkmate?(:black) || @board.tie?
      @board.render
      begin
        moving_player.play_turn
      rescue InvalidInputError => e
        puts e.message
        puts 'Be sure to use this format: 1,2'
        retry
      rescue InvalidMoveError => e
        puts e.message
        retry
      rescue MoveIntoCheckError => e
        puts e.message
        retry
      rescue NoPieceAtThisLocationError => e
        puts e.message
        retry
      rescue  NoRookForCastlingError=> e
        puts e.message
        retry
      rescue  CanNotCastlingError => e
        puts e.message
        retry
      rescue WrongColorPieceError => e
        puts e.message
        retry  
      end
      if @board.past_frequency(@history) >= 3
        puts "tie!"
        return
      end 
      
      begin
        @board.promote_pawn(moving_player.color)
      rescue InvalidInputError => e
        puts e.message
        retry
      end   
      @history << @board.dup  
      moving_player = toggle_player(moving_player)
    end
    @board.render
    
    if @board.tie?
      puts "Stalemate"
    else
      loser = moving_player
      puts "#{loser.name} is in Checkmate"
    end
  end
  
  private
  def toggle_player(moving_player)
    if moving_player == @player1
      next_player = @player2
    else
      next_player = @player1
    end
    next_player
  end
end