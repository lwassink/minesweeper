require_relative 'tile'

class Board
  NUM_OF_BOMB = 9

  def empty_grid
    Array.new(9) do |row|
      Array.new(9) do |col|
         tile = Tile.new
         tile.board = self
         tile.position = [row, col]
         tile
       end
    end
  end

  def populate #with bombs
    positions = self.bomb_positions
    self.each_with_pos do |tile, pos|
      tile.set_bomb if positions.include?(pos)
    end
  end

  def bomb_positions
    positions = []
    self.each_with_pos do |_, pos|
      positions << pos
    end
    positions.shuffle!
    positions.take(NUM_OF_BOMB)
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
    self
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

  def make_visible
    each_with_pos do |tile, _|
      tile.reveal
    end
  end
end
