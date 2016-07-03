class Solver

  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def solve
    loop do
      fill_open_list
      analyze_close_list
      break if solved?
    end
  end

  def fill_open_list
    board.fill_open_list
  end

  def solved?

  end

  def print_solution
  end

end
