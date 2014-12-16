module Chess
  class Board
    attr_accessor :grid

    def initialize
      self.grid = Array.new(8) { Array.new(8) { nil } }
    end

    def inspect

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
  end
end
