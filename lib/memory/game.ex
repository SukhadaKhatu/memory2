defmodule Memory.Game do
    def new do
        %{
            tiles: get_tiles(),
            prev: %{},
            current: %{},
            moves: 0,
        }
    end

    def client_view(game) do
        game
    end

    def reset(game) do
      %{
        tiles: get_tiles(),
        prev: %{},
        current: %{},
        moves: 0,
      }
    end

    def set_prev_current(game, tile) do
      current = Map.get(game, :current)
      prev = Map.get(game, :prev)
      if prev != %{} do
        prev_id = Map.get(prev, "id")
        prev_value = Map.get(prev, "value")
        tiles = game.tiles
        new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:id] == prev_id) do 
          tile = %{tile | clicked: false} 
          else tile = tile  end end)
        game = %{game | tiles: new_tiles}
        game = %{game | prev: current}
        game = %{game | current: tile}
      else
        game = %{game | prev: current}
        game = %{game | current: tile}
      end
    end

    def clear_state(game) do
      prev = Map.get(game, :prev)
      current = Map.get(game, :current)
      if prev != %{} && current != %{} do
        prev = Map.get(game, :prev)
        current = Map.get(game, :current)
        tiles = game.tiles
        new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:clicked] == true) do 
          tile = %{tile | clicked: false} 
          else tile = tile  end end)
        game = %{game | prev: %{}}
        game = %{game | current: %{}}
        game = %{game | tiles: new_tiles}
      else
        game 
      end
    end

    def check_match(game, tile) do
      current = Map.get(game, :current)
      prev = Map.get(game, :prev)
      tiles = game.tiles
      if current != %{} && prev != %{} do
        prev_val = Map.get(prev, "value")
        prev_id = Map.get(prev, "id")
        curr_val = Map.get(current, "value")
        curr_id = Map.get(current, "id")
        if prev_val == curr_val do
          new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:id] == prev_id || tile[:id] == curr_id) do 
            tile = %{tile | active: false} 
            else tile = tile  end end) 
          game = %{game | tiles: new_tiles}
          game = %{game | current: %{}}
          game = %{game | prev: %{}}
        else
          new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:id] == prev_id || tile[:id] == curr_id) do 
            tile = %{tile | clicked: true} 
            else tile = tile  end end) 
          game = %{game | tiles: new_tiles}
        end
      else
        tiles = game.tiles
        if prev != %{} do
          prev_id = Map.get(prev, "id")
          new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:id] == prev_id) do 
            tile = %{tile | clicked: true} 
            else tile = tile  end end)  
          game = %{game | tiles: new_tiles}
        end
        if current != %{} do
          curr_id = Map.get(current, "id")
          new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:id] == curr_id) do 
            tile = %{tile | clicked: true} 
            else tile = tile  end end)  
          game = %{game | tiles: new_tiles}
        end
      end
    end

    def set_null(game) do
      prev = Map.get(game, :prev)
      current = Map.get(game, :current)
      game = %{game | prev: %{}}
      game = %{game | current: %{}}
    end

    def increment_move(game) do
      move = Map.get(game, :moves)
      update = move + 1
      game = %{game | moves: update}  
    end
    
    def get_tiles do
      tile = [
        %{:id => 1, :clicked => false, :value => "A", :active => true},
        %{:id => 2, :clicked => false, :value => "B", :active => true},
        %{:id => 3, :clicked => false, :value => "C", :active => true},
        %{:id => 4, :clicked => false, :value => "D", :active => true},
        %{:id => 5, :clicked => false, :value => "E", :active => true},
        %{:id => 6, :clicked => false, :value => "F", :active => true},
        %{:id => 7, :clicked => false, :value => "G", :active => true},
        %{:id => 8, :clicked => false, :value => "H", :active => true},
        %{:id => 9, :clicked => false, :value => "A", :active => true},
        %{:id => 10, :clicked => false, :value => "B", :active => true},
        %{:id => 11, :clicked => false, :value => "C", :active => true},
        %{:id => 12, :clicked => false, :value => "D", :active => true},
        %{:id => 13, :clicked => false, :value => "E", :active => true},
        %{:id => 14, :clicked => false, :value => "F", :active => true},
        %{:id => 15, :clicked => false, :value => "G", :active => true},
        %{:id => 16, :clicked => false, :value => "H", :active => true},
      ]
  
      Enum.shuffle tile
    end
    
end