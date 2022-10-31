require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  let(:blue) { "\e[34m\u2b24\e[0m " }
  let(:yellow) { "\e[33m\u2b24\e[0m " }

  describe '#board_full?' do
    context 'when the board is full' do
      before do
        board.board.each_with_index do |arr, index|
          arr.each_with_index do |_el, el_i|
            board.board[index][el_i] = blue
          end
        end
      end

      it 'returns true' do
        full = board.board_full?
        expect(full).to eq(true)
      end
    end

    context 'when the board is not full' do
      it 'returns false' do
        full = board.board_full?
        expect(full).to eq(false)
      end
    end
  end

  describe '#column_full?' do
    context 'when a given column is full' do
      it 'returns true' do
        first_column = 1
        board.board.each { |i| i[first_column - 1] = yellow }
        full = board.column_full?(first_column)
        expect(full).to eq(true)
      end
    end

    context 'when a given column is not full' do
      it 'returns false' do
        second_column = 2
        full = board.column_full?(second_column)
        expect(full).to eq(false)
      end
    end
  end

  describe '#row_win?' do
    context 'when a player has 4 consecutive markers in a row' do
      before do
        board.board[5].each_index { |el| board.board[5][el] = yellow if el < 4 }
      end

      it 'returns true' do
        player = yellow
        win = board.row_win?(player)
        expect(win).to eq(true)
      end
    end

    context 'when a player doesnt have 4 consecutive markers in a row' do
      before do
        board.board[5].each_index { |el| board.board[5][el] = yellow if el < 3 }
      end

      it 'returns false' do
        player = yellow
        win = board.row_win?(player)
        expect(win).to eq(false)
      end
    end
  end

  describe '#column_win?' do
    context 'when a player has 4 consecutive markers in a column' do
      before do
        board.board.each_index { |row| board.board[row][5] = blue if row < 4 }
      end

      it 'returns true' do
        player = blue
        win = board.column_win?(player)
        expect(win).to eq(true)
      end
    end

    context 'when a player doesnt have 4 consecutive markers in a column' do
      before do
        board.board.each_index { |row| board.board[row][7] = blue if row > 2 }
      end

      it 'returns false' do
        player = blue
        win = board.column_win?(player)
        expect(win).to eq(false)
      end
    end
  end

  describe '#right_diagonal_win?' do
    context 'when a player has 4 consecutive markers diagonally from left-right (/)' do
      before do
        row = 5
        4.times do |column|
          board.board[row][column] = blue
          row -= 1
        end
      end

      it 'returns true' do
        player = blue
        win = board.right_diagonal_win?(player)
        expect(win).to eq(true)
      end
    end

    context 'when a player has 4 consecutive markers diagonally from left-right (/)' do
      before do
        row = 5
        3.times do |column|
          board.board[row][column] = blue
          row -= 1
        end
      end

      it 'returns false' do
        player = blue
        win = board.right_diagonal_win?(player)
        expect(win).to eq(false)
      end
    end
  end

  describe '#left_diagonal_win?' do
    context 'when a player has 4 consecutive markers diagonally from right-left (\)' do
      before do
        4.times do |row|
          board.board[row][row] = blue
        end
      end

      it 'returns true' do
        player = blue
        win = board.left_diagonal_win?(player)
        expect(win).to eq(true)
      end
    end

    context 'when a player doesnt have 4 consecutive markers diagonally from right-left (\)' do
      before do
        3.times do |row|
          board.board[row][row] = blue
        end
      end

      it 'returns false' do
        player = blue
        win = board.left_diagonal_win?(player)
        expect(win).to eq(false)
      end
    end
  end

  describe '#place_marker' do
    context 'when given a player and a column' do
      before do
        board.board[5][0] = blue
        allow(board).to receive(:lowest_available_row).with(1).and_return([4, 0])
      end

      it "sets the player's symbol on the last available row on the column" do
        column = 1
        player = blue
        expect { board.place_marker(player, column) }.to change { board.board[4][0] }.to(player)
      end
    end
  end

  describe '#lowest_available_row' do
    context 'when given an available column' do
      it 'returns the last row available on that column' do
        board.board[5][5] = blue
        column = 6
        free = board.lowest_available_row(column)
        expect(free).to eq([4, 5])
      end
    end
  end
end
