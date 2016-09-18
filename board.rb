require_relative 'tile'

class Board
  include Enumerable
  NUM_OF_BOMBS = 6

  def initialize(grid = empty_grid)
    @grid = grid
  end

  def empty_grid
    Array.new(9) do |row|
      Array.new(9) do |col|
         tile = Tile.new
         tile
       end
    end
  end

  def populate
    positions = self.bomb_positions

    self.each_with_pos do |tile, pos|
      tile.set_bomb if positions.include?(pos)
    end

    each_with_pos do |tile, pos|
      tile.neighbor_bomb_count = neighbor_bomb_count(pos)
    end

    self
  end

  def bomb_positions
    positions = []

    self.each_with_pos { |_, pos| positions << pos }

    positions.shuffle!
    positions.take(NUM_OF_BOMBS)
  end

  def reveal(pos)
    tile = self[pos]
    return nil if tile.revealed?

    tile.reveal
    if neighbor_bomb_count(pos) == 0
      neighbor_positions(pos).each { |npos| reveal(npos) }
    end
  end

  def neighbors(position)
    neighbor_positions(position).map { |pos| self[pos] }
  end

  def neighbor_positions(position)
    translations = [[1, 1], [1, 0], [1, -1], [0, 1],
                    [0, -1], [-1, 1], [-1, 0], [-1, -1]]

    positions = translations.map do |translation|
      [position[0] + translation[0], position[1] + translation[1]]
    end

    positions.select do |pos|
      pos.all? { |coord| coord.between?(0, size - 1) }
    end
  end

  def neighbor_bomb_count(pos)
    neighbors(pos).count { |tile| tile.bomb? }
  end

  def over?
    won? || lost?
  end

  def lost?
    self.any? { |tile| tile.revealed? && tile.bomb? }
  end

  def won?
    self.all? { |tile| tile.bomb? ? !tile.revealed? : tile.revealed? }
  end

  def inspect
    "Board size: #{size}\n#{render}"
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
    printed_board = '  ' + (1..size).to_a.join(' ')
    rows.each_with_index do |row, idx|
      printed_board << "\n#{idx + 1} #{row.map(&:to_s).join(' ')}"
    end
    printed_board
  end

  def make_visible
    each_with_pos do |tile, _|
      tile.reveal
    end
  end

  def each(&prc)
    @grid.each do |row|
      row.each { |tile| prc.call(tile) }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.populate
  b.reveal([0,0])
  # b.render
  # b.make_visible
  p b
  puts "Won: #{b.won?}"
  puts "Lost: #{b.lost?}"
end

