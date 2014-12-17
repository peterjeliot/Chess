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
          players.first.play_turn

          if board.checkmate?(players.last.color)
            puts board
            puts "Checkmate! #{players.first.name} (#{players.first.color}) won!"
            break
          end

          if board.in_check?(players.last.color)
            puts "#{other_color(players.last.color)} is in CHECK"
          end

          players.reverse!
        rescue InvalidMoveError => e
          puts e.message
        end
      end
    end
  end

end
