require_relative "board.rb"

module Chess
  SIZE = 8

  class Piece
    attr_accessor :pos, :board, :color

    def initialize(pos, board, color)
      @pos = pos
      @board = board
      @color = color
      @board[*pos] = self
    end

    def move_into_check

    end
  end

  class SlidingPiece < Piece
    def moves
      result = []

      move_dirs.each do |dir|
        pos = self.pos
        (1..8).each do |i|
          motion = dir.map { |v| v * i }
          new_pos = pairwise_add(self.pos, motion)
          r, c = new_pos
          # Todo: handle landing on opponent pieces
          break if !(new_pos.all? { |v| (0...8).include? v })
          break if !(board[r, c].nil?) && board[r, c].color == self.color
          result << new_pos
        end
      end
      result
    end

    def pairwise_add(arr1, arr2)
      arr1.zip(arr2).map { |pair| pair.reduce(:+) }
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

    def pairwise_add(arr1, arr2)
      arr1.zip(arr2).map { |pair| pair.reduce(:+) }
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
      if board[r + sign, c].nil?
        result << [r + sign, c]
      end
      unless board[r + sign, c - 1].nil?
        result << [r + sign, c - 1]
      end
      unless board[r + sign, c + 1].nil?
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

include Chess

board = Board.new
# b = Bishop.new([0,0], board, :white)
# b2 = Bishop.new([1,1], board, :white)
# r = Rook.new([1,0], board, :white)
# q = Queen.new([2,2], board, :white)
# k = Knight.new([5,0], board, :black)
# king = King.new([3,6], board, :black)
# pawn1 = Pawn.new([1,6], board, :white)
# pawn2 = Pawn.new([6,1], board, :black)

# p board[1,0].moves
board.move([1, 0], [2, 0])
# p board[2,0].moves
# p board.grid[2][0].moves
# board.move([0, 1], [2, 2])

puts board

p board[2,0].moves
board.move([2,0], [3,0])
board.in_check(:white)
