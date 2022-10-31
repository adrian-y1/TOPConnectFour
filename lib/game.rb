# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/informative_texts'

# Class that creates everything required to play the game
class Game
  include InformativeTexts
  attr_accessor :board

  def initialize(board = Board.new)
    @board = board
    @blue = "\e[34m\u2b24\e[0m "
    @yellow = "\e[33m\u2b24\e[0m "
  end

  def play_game
    puts game_rules
    setup_players
    @board.display
    loop do
      play_turn(@current_player)
      return if game_end?(@current_player)

      switch_turn
    end
  end

  def play_turn(player)
    column = get_player_column(player)
    @board.place_marker(player.color, column)
    @board.display
  end

  def setup_players
    @player_one = create_player(1, @blue)
    @player_two = create_player(2, @yellow)
    @current_player = @player_one
  end

  def create_player(player_number, color)
    puts name_info(player_number)
    loop do
      name = gets.chomp
      if name.length.between?(1, 15)
        return Player.new(name, color)
      else
        puts name_error
      end
    end
  end

  def get_player_column(player)
    puts position_info(player)
    loop do
      user_input = gets.chomp.to_i
      @user_column = verify_player_column(user_input)
      return @user_column if @user_column

      puts position_error
    end
  end

  def game_end?(player)
    if @board.game_won?(player.color)
      puts winner_text(player)
      return true
    elsif @board.board_full?
      puts no_winner_text
      return true
    end
    false
  end

  private

  def verify_player_column(column)
    return column if column.between?(1, 7) && !@board.column_full?(column)
  end

  def switch_turn
    @current_player = if @current_player == @player_one
                        @player_two
                      else
                        @player_one
                      end
  end
end

# game = Game.new
# game.play_game

# game.board.board.each { |i| i[1] = "\e[34m\u2b24\e[0m " }
# p game.board.display

# p1 = game.create_player(1, "\e[34m\u2b24\e[0m ")
# p2 = game.create_player(2, "\e[33m\u2b24\e[0m ")

# game.get_player_column(p1)
# game.get_player_column(p2)
