require_relative "board.rb"
require_relative "piece.rb"
require_relative "game.rb"
require_relative "player.rb"

require "byebug"

include Chess

player1 = HumanPlayer.new(:white)
player2 = HumanPlayer.new(:black)
g = Game.new(player1, player2)

g.play
