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
      'b'
    end
  end

  class Rook < SlidingPiece
    def move_dirs
      [[0, -1], [0, 1], [-1, 0], [1, 0]]
    end

    def to_s
      'r'
    end
  end

  class Queen < SlidingPiece
    def move_dirs
      [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    end

    def to_s
      'q'
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
      'k'
    end
  end


  class King < SteppingPiece
    def move_dirs
      [-1, 0, 1].repeated_permutation(2).to_a - [[0,0]]
    end

    def to_s
      'K'
    end
  end

  class Pawn < Piece
    def moves
      result = []
      r, c = self.pos
      sign = (self.color == :white) ? 1 : -1
      if board[r + sign, c].nil?
        result << [r + sign, c]
      end
      unless board[r + sign, c - 1].nil?
        result << [r + sign, c - 1]
      end
      unless board[r + sign, c + 1].nil?
        result << [r + sign, c + 1]
      end
      if (self.color == :black && r == 6) || (self.color == :white && r == 1)
        if board[r + sign * 2, c].nil? && board[r + sign, c].nil?
          result << [r + sign * 2, c]
        end
      end
      result
    end

    def to_s
      'p'
    end
  end
end

include Chess

board = Board.new
b = Bishop.new([0,0], board, :white)
b2 = Bishop.new([1,1], board, :white)
r = Rook.new([1,0], board, :white)
q = Queen.new([2,2], board, :white)
k = Knight.new([5,1], board, :black)
king = King.new([3,6], board, :black)
pawn1 = Pawn.new([1,6], board, :white)
pawn2 = Pawn.new([6,1], board, :black)
# r2 = Bishop.new([1,1], board)
# board[0,0] = b
# board[1,1] = b2
# board[1,0] = r
# board[2,2] = q
# board[5,1] = k
# board[3,6] = king
# board[1,6] = pawn1
# board[6,1] = pawn2

puts board
# p board[0, 0].nil?

# p b.pairwise_add([-1,-1], [5,6])
p pawn1.moves
p pawn2.moves
