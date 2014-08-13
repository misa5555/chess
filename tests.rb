require_relative 'chess'


...

p = Pawn.new...

p.move 

puts 'p.pos should be 4, 4'
puts p.pos



b = Board.generate_test_board({
  Pawn => [0, 0], 
  Knight => [5, 5]
})