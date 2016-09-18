require_relative 'board'

class Game
  def initialize(board = nil)
    @board = board || new_board
  end

  def new_board
    Board.new.populate
  end

  def play
    play_turn until over?
    conclude
  end

  def play_turn
    system("clear")
    display_board
    get_action(get_pos)
  end

  def get_pos
    print "Please enter a postion (ex. 1,3): "
    pos = parse_pos(gets.chomp)

    until valid_pos?(pos)
      print "Please enter a valid postion (ex. 1,3):"
      pos = parse_pos(gets.chomp)
    end

    pos
  end

  def parse_pos(str)
    str.split(',').map { |coord| coord.to_i - 1 }
  end

  def valid_pos?(array)
    row, col = array
    array.length == 2 &&
      array.all? { |el| el.is_a? Integer } &&
      row.between?(0, @board.row_count - 1) &&
      col.between?(0, @board.col_count - 1)
  end

  def get_action(pos)
    case read_action
    when :f
      flag(pos)
    when :r
      reveal(pos)
    when :c
      return nil
    end
  end

  def read_action
    print "Choose what you want to do (f - flag, r - reveal, c - cancel): "
    choice = gets.chomp.downcase.to_sym

    until [:f, :r, :c].include? choice
      print "Please make a valid choice (f - flag, r - reveal, c - cancel): "
      choice = gets.chomp.downcase.to_sym
    end

    choice
  end

  def reveal(pos)
    @board.reveal(pos)
  end

  def flag(pos)
    @board[pos].flag
  end

  def display_board
    puts @board.render
  end

  def over?
    @board.over?
  end

  def conclude
    system("clear")
    display_board
    if @board.won?
      puts "Congratulations, you won!"
    else
      puts "Sorry, you lost."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.custom_board
  board.populate
  game = Game.new(board)
  game.play
end
