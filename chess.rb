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
require 'colorize'

if __FILE__ == $PROGRAM_NAME
 b = Board.new
 p1 = HumanPlayer.new(b, "White", :white)
 p2 = HumanPlayer.new(b, "Black", :black)
 g = Game.new(p1, p2, b)
 g.run
end
 
 