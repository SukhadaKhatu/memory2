defmodule MemoryWeb.GamesChannel do
    use MemoryWeb, :channel
    alias Memory.Game
    alias Memory.BackupAgent

    def join("games:" <> name, payload, socket) do
      if authorized?(payload) do
        game = BackupAgent.get(name) || Game.new()
        tiles = game.tiles
        new_tiles = Enum.map(tiles, fn (tile) -> if (tile[:clicked] == true) do 
          tile = %{tile | clicked: false} 
          else tile = tile  end end)
        game = %{game | tiles: new_tiles}
        game = %{game | prev: %{}}
        game = %{game | current: %{}}
        socket = socket
        |> assign(:game, game)
        |> assign(:name, name)
        {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def handle_in("roll", _payload, socket) do
      resp = %{"roll" => :rand.uniform(6)}
      {:reply, {:roll, resp}, socket}
    end
  
    # Channels can be used in a request/response fashion
    # by sending replies to requests from the client
    def handle_in("ping", payload, socket) do
      {:reply, {:ok, payload}, socket}
    end
  
    # It is also common to receive messages from the client and
    # broadcast to everyone in the current topic (games:lobby).
    def handle_in("shout", payload, socket) do
      broadcast socket, "shout", payload
      {:noreply, socket}
    end

    def handle_in("clearstate", %{}, socket) do
      name = socket.assigns[:name]
      game = Game.clear_state(socket.assigns[:game])
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end

    def handle_in("moves", %{}, socket) do
      name = socket.assigns[:name]
      game = Game.increment_move(socket.assigns[:game])
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end

    def handle_in("prevcurrent", %{"tile" => tile}, socket) do
      name = socket.assigns[:name]
      game = Game.set_prev_current(socket.assigns[:game], tile)
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end

    def handle_in("checkmatch", %{"tile" => tile}, socket) do
      name = socket.assigns[:name]
      game = Game.check_match(socket.assigns[:game], tile)
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end

    def handle_in("setnull", %{ }, socket) do
      name = socket.assigns[:name]
      game = Game.set_null(socket.assigns[:game])
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end

    def handle_in("reset", %{}, socket) do
      name = socket.assigns[:name]
      game = Game.reset(socket.assigns[:game])
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end
  
    # Add authorization logic here as required.
    defp authorized?(_payload) do
  true
    end
  end