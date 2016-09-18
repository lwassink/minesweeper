require_relative 'board'

class Tile
  attr_accessor :neighbor_bomb_count

  def initialize(bomb = false)
    @bomb = bomb
    @revealed = false
    @flagged = false
    @neighbor_bomb_count = 0
  end

  def set_bomb
    @bomb = true
  end

  def reveal
    @revealed = true unless @flagged
  end

  def flag
    if @flagged
      @flagged = false
    else
      @flagged = true
    end
  end

  def inspect
    puts "flagged: #{@flagged}"
    puts "bomb: #{@bomb}"
    puts "revealed: #{@revealed}"
  end

  def to_s
    if revealed?
      return "B" if bomb?
      return "_" if neighbor_bomb_count == 0
      neighbor_bomb_count.to_s
    else
      return "F" if flagged?
      "*"
    end
  end

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end

  def bomb?
    @bomb
  end
end

