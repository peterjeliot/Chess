module Chess
  class HumanPlayer
    attr_accessor :board, :color, :name

    def initialize(name, color)
      @name = name
      @color = color
      @cursor_pos = [0, 0]
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
      # @cursor_pos = [0, 0]
      loop do
        start_pos = get_start_pos
        next if start_pos.nil?

        end_pos = get_end_pos(start_pos)
        return [start_pos, end_pos]
      end
    end


    def get_start_pos
      loop do
        new_cursor_pos = @cursor_pos.dup
        puts board.to_s(cursor_pos: @cursor_pos)
        case STDIN.getch
        when 'q'
          exit
        when "\r"
          piece = board[*new_cursor_pos]
          next if piece.nil? || piece.color != self.color
          return @cursor_pos
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
        if new_cursor_pos.all? { |pos| pos.between?(0, 7) }
          @cursor_pos = new_cursor_pos
        end
      end
    end

    def get_end_pos(start_pos)
      piece = board[*start_pos]
      @cursor_pos = start_pos.dup
      loop do
        new_cursor_pos = @cursor_pos.dup
        puts board.to_s(cursor_pos: @cursor_pos, moves: piece.moves)
        case STDIN.getch
        when "q"
          exit
        when "c"
          return nil
          break
        when "\r"
          return @cursor_pos
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
        if new_cursor_pos.all? { |pos| pos.between?(0, 7) }
          @cursor_pos = new_cursor_pos
        end
      end
    end

    private
      attr_accessor :cursor_pos
  end
end
