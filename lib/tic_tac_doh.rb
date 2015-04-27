require 'tic_tac_doh/version'

module TicTacDoh
  class Game

    attr_reader :players, :grid

    def initialize(args={})
      @players = []
      @turn = 0
      args.fetch(:board_size, 3).times do
        @grid = Array.new(3) {}
      end
    end

    def reset
      prepare_grid
      @turn = rand(0..players.count)
    end

    def next_turn(cell_position)
      insert_player_move_in_grid(calculate_cell(cell_position))
    end

    def who_is_next
      { nickname: players[player_turn].nickname, mark: players[player_turn].mark }
    end

    def player_turn
      @turn % players.count
    end

    def set_board_size(size)
      prepare_grid(size)
    end

    def scoreboard
      scoreboard = []
      players.each do |player|
        scoreboard << { nickname: player.nickname, score: player.score }
      end
      scoreboard
    end

    def add_player(args)
      if valid_mark(args[:mark])
        players << Player.new(args)
        true
      else
        false
      end
    end

    def game_over?
      # Winner
      if symbol_winner?
        return true
      end
      return false unless free_cells?
      true
    end

    def free_cells?
      @grid.each do |row|
        row.each do |cell|
          return false if cell.is_a? Numeric
        end
      end
      true
    end

    def winner
      return find_player_by(mark: symbol_winner?) if symbol_winner?
      false
    end

    private

    def valid_mark(mark)
      players.each do |player|
        if player.mark == mark[0]
          return false
        end
      end
      true
    end

    def prepare_grid(size=grid.length)
      @grid = []
      array = []
      for cell in 0...size
        for cell2 in cell * size...(cell * size + size)
          array << cell2
        end
        @grid << array
        array = []
      end
    end

    def symbol_winner?
      winner_mark = nil
      grid.length.times do |n|
        grid.length.times do |m|
          winner_mark ||= secuential_mark(grid[n][m], n,0,0,1) # horizontal search
          winner_mark ||= secuential_mark(grid[m][n], 0,n,1,0) # vertical search
          winner_mark ||= secuential_mark(grid[m][n], m,n,1,1) # diagonal +
          winner_mark ||= secuential_mark(grid[m][n], m,n,-1,1) # diagonal -
        end
      end
      return winner_mark
    end

    def find_player_by(args={})
      players.each { |player| return { nickname: player.nickname, mark: player.mark } if player.mark == args[:mark] }
      false
    end

    def secuential_mark(mark, row, col, row_step, col_step, counter=1)
      return nil unless within_grid_range?(row, col)
      if grid[row][col] == mark
        return grid[row][col] if counter == 3
        return secuential_mark(mark, row + row_step, col + col_step, row_step, col_step, counter+1)
      else
        return nil
      end
    end

    def within_grid_range? (arg, col)
      if arg.is_a? Hash
        return true if arg[:row] < grid.length && arg[:col] < grid.length if arg[:row] >= 0 && arg[:col] >= 0
      else
        return true if arg < grid.length && col < grid.length if arg >= 0 && col >= 0
      end
      false
    end

    def calculate_cell(cell_number)
      row = 0
      for n in 0..cell_number
        row += 1 if (n % grid.size) == 0 unless n == 0
      end
      column = cell_number - (row * grid.size)
      {row: row, column: column}
    end

    def insert_player_move_in_grid(position)
      return false unless valid_move? position
      @grid[position[:row]][position[:column]] = who_is_next[:mark]
      @turn += 1
      true
    end

    def valid_move?(position)
      return false if position[:row] < 0 || position[:row] > (@grid.length) - 1
      return false if position[:column] < 0 || position[:column] > (@grid.length) - 1
      return false unless @grid[position[:row]][position[:column]].is_a? Numeric
      true
    end
  end

  class Player
    attr_reader :nickname, :score

    def initialize(args={})
      @nickname = args.fetch(:nickname, "Anonymous#{rand(100)}")
      @score = 0
      @mark = args[:mark]
    end

    def add_to_score(score)
      @score += score
    end

    def mark
      @mark[0]
    end
  end
end
