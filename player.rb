module Chess
  class HumanPlayer
    attr_accessor :board, :color

    def initialize(color)
      @color = color
    end

    def play_turn
      board.move(*get_move, self.color)
    end

    def get_move
      print "What is your move, #{color}? (r c r c) "
      move = gets.chomp.scan(/[0-9]/).map { |c| c.to_i }
      from = move.take(2)
      to = move.drop(2)

      [from, to]
    end
  end
end
