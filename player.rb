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
      move = gets
      if move.nil?
        puts "\nReached the end of test input file."
        exit
      end
      move = move.chomp.scan(/([a-h])([1-8])/).map(&:reverse)
      from, to = move

      # Convert from human readable chess format to r, c indexes
      letters = %w(a b c d e f g h)
      move.map { |pos| [8 - pos.first.to_i, letters.index(pos.last)] }
    end

    def get_move
      cursor_pos = [0, 0]
      loop do
        new_cursor_pos = cursor_pos.dup
        puts "\e[H\e[2J" #control code for clearing screen
        puts board.to_s(cursor_pos)
        #todo
        case STDIN.getch
        when 'q'
          exit
        when "\e"
          STDIN.getch
          case STDIN.getch
          when "A"
            new_cursor_pos[0] -= 1
          when "B"
            new_cursor_pos[0] += 1
          when "C"
            new_cursor_pos[1] += 1
          when "D"
            new_cursor_pos[1] -= 1
          end
        end
        cursor_pos = new_cursor_pos if new_cursor_pos.all? { |pos| pos.between?(0, 9) }
      end

      cursor_pos
    end

  end
end
