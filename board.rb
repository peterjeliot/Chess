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
      Knight.new([5,5], self, :black)

    end

    def to_s
      result = ''
      self.grid.each do |row|
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

    def []= (r, c, val)
      self.grid[r][c] = val
    end

    def move(start, end_pos)
      # Todo: Needs refactoring
      start_r, start_c = start
      end_r, end_c = end_pos

      piece = self.grid[start_r][start_c]

      raise InvalidMoveError if piece.nil? || !piece.moves.include?(end_pos)

      # if piece.moves.include?(end_pos)
      #   self[*start], self[*end_pos] = self[*end_pos], self[*start]
      #   piece.pos = end_pos
      # end

      self.grid[start_r][start_c], self.grid[end_r][end_c] =
      self.grid[end_r][end_c], self.grid[start_r][start_c]
      piece.pos = end_pos
    end

    def in_check(color)
      king = nil
      # Find the {color} king
      self.grid.each do |r|
        r.each_with_index do |val, i|
          unless val.nil?
            king = val if val.class == King and val.color == color
          end
        end
      end
      # Find pieces that can move to {color} king's position
      check = false
      self.grid.each do |r|
        r.each_with_index do |val, i|
          unless val.nil?
            check = true if val.moves.include?(king.pos)
          end
        end
      end


      puts "This is the #{color} king's position: #{king.pos}"
      puts "Check" if check
    end

  end
end
