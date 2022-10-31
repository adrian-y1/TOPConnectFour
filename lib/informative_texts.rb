# frozen_string_literal: true

# Module that displays Informative texts to the console
module InformativeTexts
  @blue = "\e[34m\u2b24\e[0m "
  @yellow = "\e[33m\u2b24\e[0m "

  def game_rules
    <<~HEREDOC
      \e[32mWelcome to Connect Four!\n
      Connect Four is a 2 player game where each player takes a turn to insert their circle in a selected column.\n
      To win, a player must have 4 consecutive circles in any of the following directions:\n
      Row\nColumn\nDiagonal\n
      Player 1 plays with the \e \e[34mblue circle \e \e[32mand Player 2 plays with the \e \e[33myellow circle\e.
        \e[32mGood Luck!\e\n
    HEREDOC
  end

  def name_info(player)
    "#{
      player == 1 ? turn_blue("Player #{player}") : turn_yellow("Player #{player}")
    }, please enter your name:"
  end

  def name_error
    turn_red('Please enter a name between 1-15 characters long:')
  end

  def position_info(player)
    "#{player_name_color(player)}, enter a column number between 1-7:"
  end

  def position_error
    turn_red('Please enter a valid column between 1-7:')
  end

  def winner_text(player)
    "\e[32mCongratulations \e #{player_name_color(player)}, \e[32myou have won the game!\e"
  end

  def no_winner_text
    "\e[30mGame Over! The game ended in a draw.\e"
  end

  def turn_blue(text)
    "\e[34m#{text}\e[0m "
  end

  def turn_yellow(text)
    "\e[33m#{text}\e[0m "
  end

  def turn_red(text)
    "\e[31m#{text}\e[0m "
  end

  def player_name_color(player)
    player.color == @blue ? turn_blue(player.name) : turn_yellow(player.name)
  end
end
