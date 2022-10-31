require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:blue) { "\e[34m\u2b24\e[0m " }
  let(:yellow) { "\e[33m\u2b24\e[0m " }

  describe '#play_game' do
    let(:board_play) { instance_double(Board) }
    subject(:game_play) { described_class.new(board_play) }

    before do
      allow(game_play).to receive(:puts)
      allow(game_play).to receive(:game_rules)
      allow(game_play).to receive(:setup_players)
      allow(board_play).to receive(:display)
      allow(game_play).to receive(:play_turn)
      allow(game_play).to receive(:game_end?).and_return(false, false, false, true)
    end

    it 'stops loop when the game has ended' do
      expect(game_play).to receive(:play_turn).exactly(4).times
      game_play.play_game
    end

    it 'sends display' do
      expect(board_play).to receive(:display).once
      game_play.play_game
    end
  end

  describe '#play_turn' do
    context "when placing a player's marker on the board" do
      let(:player_one) { instance_double(Player, name: 'adrian', color: blue) }
      let(:board_turn) { double('board') }
      subject(:game_turn) { described_class.new(board_turn) }

      before do
        allow(game_turn).to receive(:get_player_column).and_return(3)
        allow(board_turn).to receive(:display)
      end

      it 'sends place_marker' do
        user_column = 3
        expect(board_turn).to receive(:place_marker).with(player_one.color, user_column)
        game_turn.play_turn(player_one)
      end
    end
  end

  describe '#create_player' do
    context 'when given a valid input' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:name_info).with(1)
        valid_input = 'adrian'
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'doesnt receive error message' do
        expect(game).to_not receive(:name_error)
        game.create_player(1, blue)
      end

      it 'creates a new player then stops loop' do
        expect(Player).to receive(:new).with('adrian', blue)
        game.create_player(1, blue)
      end
    end

    context 'when given an invalid input, then a valid input' do
      before do
        allow(game).to receive(:puts).twice
        allow(game).to receive(:name_info).with(1)
        allow(game).to receive(:name_error)
        invalid_input = 'asdfghjkllkjhgfsad'
        valid_input = 'adrian'
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'displays error message once' do
        expect(game).to receive(:name_error).once
        game.create_player(1, blue)
      end

      it 'creates new player then stops loop' do
        expect(Player).to receive(:new).with('adrian', blue)
        game.create_player(1, blue)
      end
    end
  end

  describe '#get_player_column' do
    let(:player_one) { instance_double(Player, name: 'p1', color: blue) }

    context "when a player's input is valid" do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:position_info).with(player_one)
        valid_input = '5'
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'stops loop and does not display error message' do
        expect(game).to_not receive(:position_error)
        game.get_player_column(player_one)
      end
    end

    context 'when a player inputs invalid then a valid input' do
      before do
        allow(game).to receive(:puts).twice
        allow(game).to receive(:position_info).with(player_one)
        allow(game).to receive(:position_error)
        invalid_input = '23'
        valid_input = '5'
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'displays error message once, and stops loop' do
        expect(game).to receive(:position_error).once
        game.get_player_column(player_one)
      end
    end
  end

  describe '#game_end' do
    let(:player_one) { instance_double(Player, name: 'adrian', color: blue) }
    let(:board_end) { double('board') }
    subject(:game_finished) { described_class.new(board_end) }

    context 'when a player has won the game' do
      before do
        allow(board_end).to receive(:game_won?).with(player_one.color).and_return(true)
      end

      it 'returns true' do
        expect(game_finished).to receive(:puts).once
        game_finished.game_end?(player_one)
      end
    end

    context 'when the board is full' do
      before do
        allow(board_end).to receive(:game_won?).with(player_one.color).and_return(false)
        allow(board_end).to receive(:board_full?).and_return(true)
      end

      it 'returns true' do
        expect(game_finished).to receive(:puts).once
        game_finished.game_end?(player_one)
      end
    end

    context 'when the board is not full and there is no winner' do
      before do
        allow(board_end).to receive(:game_won?).with(player_one.color).and_return(false)
        allow(board_end).to receive(:board_full?).and_return(false)
      end

      it 'returns false' do
        expect(game_finished).to_not receive(:puts)
        game_finished.game_end?(player_one)
      end
    end
  end
end
