# encoding: utf-8

require './piece'
require './stepping_piece'
require './sliding_piece'
require './rook'
require './bishop'
require './knight'
require './queen'
require './king'
require './pawn'
require './board'
require './game'
require './human_player'
require './errors'

if __FILE__ == $PROGRAM_NAME
 b = Board.new
 p1 = HumanPlayer.new(b, "A")
 p2 = HumanPlayer.new(b, "B")
 g = Game.new(p1, p2, b)
 g.run
end
 
 