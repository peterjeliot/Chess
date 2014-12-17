module Chess

  class Game
    attr_accessor :players, :board

    def initialize(player1, player2)
      @players = [player1, player2]
      @board = Board.new
      player1.board = board
      player2.board = board
    end

    def play
      loop do
        begin
          puts board
          players.first.play_turn

          if board.in_check?(players.last.color)
            puts "#{other_color(piece.color)} is in CHECK"
          end

          players.reverse!
        rescue InvalidMoveError => e
          puts e.message
        end
      end
    end
  end

end
