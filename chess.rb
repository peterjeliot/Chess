require_relative "board.rb"
require_relative "piece.rb"
require_relative "game.rb"
require_relative "player.rb"
require_relative "helpers.rb"

require "byebug"

include Chess

player1 = HumanPlayer.new("Davide", :white)
player2 = HumanPlayer.new("Peter", :black)
g = Game.new(player1, player2)

g.play
