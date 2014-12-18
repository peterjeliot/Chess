module Chess

  class Game
    attr_accessor :players, :board

    def initialize(player1, player2)
      @players = [player1, player2]
      player1.board = player2.board = @board = Board.new
    end

    def play
      loop do
        begin
          puts board

          current_player, next_player = players

          if board.stalemate?(current_player.color)
            puts "Stalemate! Nobody wins!"
            break
          elsif board.checkmate?(current_player.color)
            puts "Checkmate! #{next_player.name} (#{next_player.color}) won!"
            break
          elsif board.in_check?(current_player.color)
            puts "You are in check."
          end

          current_player.play_turn
          players.reverse!
        rescue InvalidMoveError => e
          puts e.message
        end
      end
    end
  end

end
