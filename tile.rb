require_relative 'board'

class Tile
  attr_accessor :position, :board

  def initialize(bomb = false)
    @bomb = bomb
    @revealed = false
    @flag = false
    @position = nil
    @board = nil
  end

  def neighbors
    #input - tile.position
    #[1,1]
    #output - array [8 tiles] which are the neighbors of the input tile
    neighbor_positions.map { |pos| @board[pos] }
  end

  def neighbor_positions
    translations = [
      [1, 1],
      [1, 0],
      [1, -1],
      [0, 1],
      [0, -1],
      [-1, 1],
      [-1, 0],
      [-1, -1]
    ]
    #postions here = neighbor positions
    positions = translations.map do |translation|
      [@position[0] + translation[0], @position[1] + translation[1]]
    end

    positions.select do |pos|
      pos.all? { |coord| coord.between?(0, @board.size - 1) }
    end
  end

  def neighbor_bomb_count
    neighbors.count { |tile| tile.bomb? }
  end

  def set_bomb
    @bomb = true
  end

  def reveal
    @revealed = true unless @flag
  end

  def flag
    if @flag
      @flag = false
    else
      @flag = true
    end
  end

  def inspect
    puts "flag: #{@flag}"
    puts "bomb: #{@bomb}"
    puts "revealed: #{@revealed}"
  end

  def to_s
    if revealed?
      return "B" if bomb?
      return "_" if neighbor_bomb_count == 0
      neighbor_bomb_count.to_s
    else
      return "F" if flag?
      "*"
    end
  end

  def revealed?
    @revealed
  end

  def flag?
    @flag
  end

  def bomb?
    @bomb
  end
end
