require_relative 'tile'

class Board
  include Enumerable

  def self.custom_board
    print "Enter the number of rows and columns you want (ex. 9,9): "
    dimensions = self.parse_dimensions(gets.chomp)

    until self.valid_dimensions?(dimensions)
      print "Please enter valid dimensions (ex. 9,9)"
      dimensions = self.parse_dimensions(gets.chomp)
    end

    self.new(self.empty_grid(*dimensions))
  end

  def self.valid_dimensions?(array)
    array.length == 2 &&
      array.all? { |el| el.is_a?(Integer) && el.between?(1,29) }
  end

  def self.parse_dimensions(str)
    str.split(',').map(&:to_i)
  end

  def self.empty_grid(rows, cols)
    Array.new(rows) do |row|
      Array.new(cols) do |col|
         tile = Tile.new
         tile
       end
    end
  end

  def initialize(grid = nil)
    @grid = grid || self.class.empty_grid(9,9)
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
    positions.take(bomb_count)
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
      row, col = pos
      row.between?(0, row_count - 1) && col.between?(0, col_count - 1)
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
    "Board size: #{row_count} x #{col_count}\n#{render}"
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

  def row_count
    @grid.length
  end

  def col_count
    @grid.first.length
  end

  def size
    col_count * row_count
  end

  def render
    printed_board = (row_count >= 10 ? '   ' : '  ')

    (1..col_count).each do |i|
      printed_board << i.to_s.colorize(:blue)
      printed_board << (i >= 10 ? ' ' : '  ')
    end

    @grid.each_with_index do |row, idx|
      printed_board << "\n"
      printed_board << (idx + 1).to_s.colorize(:blue)
      printed_board << ' '
      printed_board << ' ' if row_count >= 10 && idx < 9
      printed_board << row.map(&:to_s).join('  ')
    end

    printed_board
  end

  def bomb_count
    (size) / 9
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
  b = Board.custom_board
  b.populate
  b.reveal([3,3])
  b.make_visible
  p b
  puts "Won: #{b.won?}"
  puts "Lost: #{b.lost?}"
end

