require_relative 'tile'

class Board
  def empty_grid
    Array.new(9) do
      Array.new(9) { Tile.new }
    end
  end

  def self.populated_grid
    board = Board.new
    board.each_with_pos do |tile, _|
      tile.set_bomb
    end
    board
  end

  def initialize(grid = empty_grid)
    @grid = grid
  end

  def inspect
    size
  end

  def each_with_pos(&prc)
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        prc.call(tile, [idx1, idx2])
      end
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def size
    @grid.length
  end

  def rows
    @grid
  end

  def render
    puts '  ' + (0...size).to_a.join(' ')
    rows.each_with_index do |row, idx|
      print "#{idx} "
      puts row.map(&:to_s).join(' ')
    end
    self
  end
end
