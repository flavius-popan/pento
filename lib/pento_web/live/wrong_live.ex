defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @num_range 1..10

  defp initial_assigns do
    %{
      score: 0,
      message: "Make a guess:",
      num_range: @num_range,
      secret_number: rand_int(@num_range),
      won_game: false
    }
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, initial_assigns())}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
      <%= if @won_game do %>
        <.link patch={~p"/guess"} class="font-bold"> Restart? </.link>
      <% end %>
    </h2>
    <br />
    <h2>
      <%= for n <- @num_range do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
    text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          {n}
        </.link>
      <% end %>
    </h2>
    """
  end

  def rand_int(range) do
    Enum.random(range)
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    secret_number = socket.assigns.secret_number

    {message, score, secret_number, won_game?} =
      if String.to_integer(guess) == secret_number do
        {"Your guess: #{guess}. Correct!", socket.assigns.score + 1, rand_int(@num_range), true}
      else
        {"Your guess: #{guess}. Wrong. Guess again.", socket.assigns.score - 1, secret_number,
         false}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        secret_number: secret_number,
        won_game: won_game?
      )
    }
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, assign(socket, initial_assigns())}
  end
end
