module Chess
  class HumanPlayer
    attr_accessor :board, :color, :name

    def initialize(name, color)
      @name = name
      @color = color
    end

    def play_turn
      board.move(*get_move, self.color)
    end

    def get_move
      print "What is your move, #{color}? "
      move = gets.chomp.scan(/([a-h])([1-8])/).map(&:reverse)
      from, to = move

      # Convert from human readable chess format to r, c indexes
      letters = %w(a b c d e f g h)
      move.map { |pos| [8 - pos.first.to_i, letters.index(pos.last)] }
    end
  end
end
