module Chess

  class InvalidMoveError < ArgumentError
  end

  class Board
    attr_accessor :grid

    def initialize
      self.grid = Array.new(8) { Array.new(8) { nil } }

      # Setup chess pieces
      8.times do |i|
        Pawn.new([1, i], self, :black)
        Pawn.new([6, i], self, :white)
      end
      2.times do |i|
        i = 7 if i == 1
        Rook.new([0, i], self, :black)
        Rook.new([7, i], self, :white)
      end

      [[0,1], [0, 6], [7, 1], [7, 6]].each do |(r, c)|
        color = r < 3 ? :black : :white
        Knight.new([r, c], self, color)
      end

      [[0,2], [0, 5], [7, 2], [7, 5]].each do |(r, c)|
        color = r < 3 ? :black : :white
        Bishop.new([r, c], self, color)
      end

      King.new([0, 4], self, :black)
      King.new([7, 4], self, :white)
      Queen.new([0, 3], self, :black)
      Queen.new([7, 3], self, :white)

      # Testing for check (delete for production)
      # Knight.new([5,5], self, :black)
      # Bishop.new([2,6], self, :white)
    end

    def to_s
      result = "—————————————————\n  0 1 2 3 4 5 6 7\n"
      self.grid.each_with_index do |row, r|
        result << r.to_s << " "
        row.each do |el|
          result << ((el.nil?) ? '.' : el.to_s) + ' '
        end
        result << "|\n"
      end
      result
    end

    def [] (r, c)
      self.grid[r][c]
    end

    def []=(r, c, val)
      self.grid[r][c] = val
    end

    def other_color(color)
      (color == :white) ? :black : :white
    end

    def move(start, end_pos, color)
      piece = self[*start]

      if piece.nil?
        raise InvalidMoveError.new "No piece there."
      elsif color != piece.color
        raise InvalidMoveError.new "Can't move opponent's piece."
      elsif !piece.moves.include?(end_pos)
        raise InvalidMoveError.new "Not in the #{piece.class}'s moveset."
      end

      test_move_board = self.dup
      test_move_board.move!(start, end_pos)
      if test_move_board.in_check?(piece.color)
        raise InvalidMoveError.new "Not allowed to move into check"
      end

      self.move!(start, end_pos)
    end

    def move!(start, end_pos)
      start_r, start_c = start
      end_r, end_c = end_pos

      piece = self.grid[start_r][start_c]

      if piece.nil? || !piece.moves.include?(end_pos)
        raise InvalidMoveError.new "Bad move: #{start} to #{end_pos}"
      end

      self[start_r, start_c], self[end_r, end_c] = self[*end_pos], self[*start]
      piece.pos = end_pos

      nil
    end

    def in_check?(color)
      pieces = grid.flatten.compact
      our_king = pieces.find { |p| p.is_a?(King) && (p.color == color) }
      pieces.any? { |p| p.color != color && p.moves.include?(our_king.pos) }
    end

    def checkmate?(color)
      return false if !in_check?(color)
      p in_check? :black

      self.grid.each_with_index do |row, r|
        row.each_with_index do |piece, c|
          next if piece.nil? || piece.color != color
          piece.moves.each do |new_pos|
            dup_board = self.dup
            dup_board.move!([r, c], new_pos)
            if !dup_board.in_check?(color)
              p "this gets us out of check: #{[r, c]} to #{new_pos}"
              return false
            end
          end
        end
      end
      true
    end

    def dup
      dup_board = Board.new


      # Iterate through grid, create new objs with same par, feed dup_board
      self.grid.each_with_index do |r, i|
        r.each_with_index do |el, j|
          if el.nil?
            dup_board[i, j] = nil
          else
            # el_class = el.class
            # el_pos = el.pos
            # el_color = el.color
            dup_board[i, j] = el.class.new([i, j], dup_board, el.color)
          end
        end
      end

      dup_board
    end
  end
end
