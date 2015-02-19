require_relative "board.rb"
require_relative "piece.rb"
require_relative "game.rb"
require_relative "player.rb"
require_relative "helpers.rb"

include Chess

davide = HumanPlayer.new("Davide", :white)
peter = HumanPlayer.new("Peter", :black)
c1 = ComputerPlayer.new("ShallowBlue", :black)
c2 = ComputerPlayer.new("Tiny Robot", :white)

# loop do
  g = Game.new(c1, c2)

  g.play
# end
