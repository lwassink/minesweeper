require_relative 'board'
require 'colorize'

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
      return "B".colorize(:red) if bomb?
      return "_" if neighbor_bomb_count == 0
      neighbor_bomb_count.to_s.colorize(:green)
    else
      return "F".colorize(:yellow) if flagged?
      "*".colorize(:grey)
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

if __FILE__ == $PROGRAM_NAME
  t = Tile.new
  puts t
  t.flag
  puts t
  t.flag
  t.reveal
  puts t
  t.neighbor_bomb_count = 3
  puts t
  t.set_bomb
  puts t
end

