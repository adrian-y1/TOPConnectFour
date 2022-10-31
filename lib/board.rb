# frozen_string_literal: true

# Class that creates a board and its required methods
class Board
  attr_accessor :board

  def initialize
    @init_circle = "\u2b55"
    @board = Array.new(6) { Array.new(7) { @init_circle } }
    @blue = "\e[34m\u2b24\e[0m "
    @yellow = "\e[33m\u2b24\e[0m "
  end

  def game_won?(player)
    row_win?(player) || column_win?(player) || diagonal_win?(player)
  end

  def board_full?
    @board.all? { |sub_arr| sub_arr.all? { |el| el != @init_circle } }
  end

  def column_full?(column)
    @board.all? { |sub_arr| sub_arr[column - 1] != @init_circle }
  end

  def place_marker(player, column)
    row = lowest_available_row(column)
    @board[row[0]][row[1]] = player
  end

  def lowest_available_row(column)
    last_row = @board.length - 1
    @board.length.times do |_i|
      return [last_row, column - 1] if @board[last_row][column - 1] == @init_circle

      last_row -= 1
    end
  end

  def row_win?(player)
    @board.any? do |sub_arr|
      (0..3).all? { |i| sub_arr[i] == player } or
        (1..4).all? { |i| sub_arr[i] == player } or
        (2..5).all? { |i| sub_arr[i] == player } or
        (3..6).all? { |i| sub_arr[i] == player }
    end
  end

  def column_win?(player)
    @board.any? do |sub_arr|
      sub_arr.each_index.any? do |column|
        (0..3).all? { |i| @board[i][column] == player } or
          (1..4).all? { |i| @board[i][column] == player } or
          (2..5).all? { |i| @board[i][column] == player }
      end
    end
  end

  def diagonal_win?(player)
    right_diagonal_win?(player) || left_diagonal_win?(player)
  end

  def right_diagonal_win?(player)
    @board.each_index.any? do |row|
      @board[row].each_index.any? do |column|
        (0..3).all? { |i| @board[row - i][column + i] == player } if row > 2 && column < 4
      end
    end
  end

  def left_diagonal_win?(player)
    @board.each_index.any? do |row|
      @board[row].each_index.any? do |column|
        (0..3).all? { |i| @board[row - i][column - i] == player } if row > 2 && column > 2
      end
    end
  end

  def display
    puts "\n"
    @board.each do |row|
      puts row.join(' ')
    end
    puts "1  2  3  4  5  6  7\n\n"
  end
end
