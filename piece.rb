module Chess
  class Piece
    attr_accessor :pos, :board, :color

    def initialize(board, color)
      @board = board
      @color = color
    end

    def move_into_check?(pos)
      dup_board = @board.dup
      dup_board.move!(self.pos, pos)
      dup_board.in_check?(self.color)
    end

    def inspect
      "(#{self.color} #{self.to_s}  at #{self.pos})"
    end
  end

  class SlidingPiece < Piece
    def moves
      result = []

      move_dirs.each do |dir|
        pos = self.pos
        (1..8).each do |magnitude|
          motion = dir.map { |v| v * magnitude }
          new_pos = pairwise_add(self.pos, motion)
          break if !(new_pos.all? { |v| (0...8).include? v })
          break if !(board[*new_pos].nil?) && board[*new_pos].color == self.color
          if !(board[*new_pos].nil?) && board[*new_pos].color != self.color
            result << new_pos
            break
          end
          result << new_pos
        end
      end
      result
    end
  end

  class Bishop < SlidingPiece
    def move_dirs
      [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    end

    def to_s
      color == :black ? "\u265D" : "\u2657"
    end
  end

  class Rook < SlidingPiece
    def move_dirs
      [[0, -1], [0, 1], [-1, 0], [1, 0]]
    end

    def to_s
      color == :black ? "\u265C" : "\u2656"
    end
  end

  class Queen < SlidingPiece
    def move_dirs
      [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    end

    def to_s
      color == :black ? "\u265B" : "\u2655"
    end
  end

  class SteppingPiece < Piece
    def moves
      result = []
      move_dirs.each do |dir|
        pos = self.pos
        new_pos = pairwise_add(self.pos, dir)
        r, c = new_pos
        # Todo: handle landing on opponent pieces
        # todo: dry this out
        next if !(new_pos.all? { |v| (0...8).include? v })
        next if !(board[r, c].nil?) && board[r, c].color == self.color
        result << new_pos
      end
      result
    end
  end

  class Knight < SteppingPiece
    def move_dirs
      [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    end

    def to_s
      color == :black ? "\u265E" : "\u2658"
    end
  end


  class King < SteppingPiece
    def move_dirs
      [-1, 0, 1].repeated_permutation(2).to_a - [[0,0]]
    end

    def to_s
      color == :black ? "\u265A" : "\u2654"
    end
  end

  class Pawn < Piece
    def moves
      result = []
      r, c = self.pos
      sign = (self.color == :white) ? -1 : 1
      
      #todo: replace this with exchanging the piece
      return [] if !(0...8).include?(r + sign)

      if board[r + sign, c].nil?
        result << [r + sign, c]
      end
      unless board[r + sign, c - 1].nil? || board[r + sign, c - 1].color == self.color
        result << [r + sign, c - 1]
      end
      unless board[r + sign, c + 1].nil? || board[r + sign, c + 1].color == self.color
        result << [r + sign, c + 1]
      end
      if (self.color == :white && r == 6) || (self.color == :black && r == 1)
        if board[r + sign * 2, c].nil? && board[r + sign, c].nil?
          result << [r + sign * 2, c]
        end
      end
      result
    end

    def to_s
      color == :black ? "\u265F" : "\u2659"
    end
  end
end
