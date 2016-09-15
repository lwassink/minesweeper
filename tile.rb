require_relative 'board'

class Tile

  def initialize(bomb = false)
    @bomb = bomb
    @revealed = false
    @flag = false
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
      return "b" if bomb?
      return "_"
    else
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
