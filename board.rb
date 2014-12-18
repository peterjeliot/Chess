module Chess
  class InvalidMoveError < ArgumentError
  end

  class Board
    attr_accessor :grid

    def initialize(options = {})
      default_options = { blank: false }
      options = default_options.merge(options)

      self.grid = Array.new(8) { Array.new(8) { nil } }
      return if options[:blank]

      [[:white, 7, 6], [:black, 0, 1]].each do |color, r, pawn_r|
        self[r, 0] = Rook.new(self, color)
        self[r, 1] = Knight.new(self, color)
        self[r, 2] = Bishop.new(self, color)
        self[r, 3] = Queen.new(self, color)
        self[r, 4] = King.new(self, color)
        self[r, 5] = Bishop.new(self, color)
        self[r, 6] = Knight.new(self, color)
        self[r, 7] = Rook.new(self, color)
        (0...8).each do |c|
          self[pawn_r, c] = Pawn.new(self, color)
        end
      end
    end

    def to_s(options = {})
      default_options = { cursor_pos: nil, moves: []}
      options = default_options.merge(options)
      result = "\e[H\e[2J  a b c d e f g h\n"
      self.grid.each_with_index do |row, r|
        result << (8 - r).to_s << " "
        row.each_with_index do |piece, c|
          text_color = :white
          background = nil
          if [r, c] == options[:cursor_pos]
            text_color = :red
          end
          if options[:moves].include?([r, c])
            background = :cyan
          end
          str = ((piece.nil?) ? '_' : piece.to_s)
          result << str.colorize(color: text_color, background: background) + ' '
        end
        result << "\n"
      end
      result << "\n"
      result << "   key: action\n"
      result << "—————————————————————\n"
      result << "arrows: move cursor\n"
      result << " enter: select\n"
      result << "     c: cancel\n"
      result << "     q: quit\n"
      result
    end

    def [] (r, c)
      self.grid[r][c]
    end

    def []=(r, c, piece)
      self.grid[r][c] = piece
      piece.pos = [r, c] if !piece.nil?
    end

    def pieces(color = nil)
      grid.flatten.compact.select do |piece|
        color.nil? || color == piece.color
      end
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
      piece = self[*start]

      self[*start] = nil
      self[*end_pos] = piece

      nil
    end

    def in_check?(color)
      our_king = pieces(color).find { |p| p.is_a?(King) }
      pieces(other_color(color)).any? { |p| p.moves.include?(our_king.pos) }
    end

    def checkmate?(color)
      return false if !in_check?(color)

      pieces(color).each do |piece|
        piece.moves.each do |new_pos|
          dup_board = self.dup
          dup_board.move!(piece.pos, new_pos)
          return false if !dup_board.in_check?(color)
        end
      end

      true
    end

    def dup
      dup_board = Board.new(blank: true)

      pieces.each do |piece|
        dup_board[*piece.pos] = piece.class.new(dup_board, piece.color)
      end

      dup_board
    end
  end
end
