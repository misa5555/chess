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

#if __FILE__ == $PROGRAM_NAME
  # b = Board.generate_test_board([
 #    [Bishop, [3, 4], :white],
 #    [Pawn, [6, 6], :white],
 #    [King, [7, 6], :black]
 #    ])
 #  k = b.grids[7][6]
 #  p k.move_into_check?([7,7])
 #
 #  b.render
 #
 b = Board.new
 p1 = HumanPlayer.new(b, "A")
 p2 = HumanPlayer.new(b, "B")
 g = Game.new(p1, p2, b)
 g.run
 
 