defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @num_range 1..10

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       num_range: @num_range,
       rand_int: rand_int(@num_range)
     )}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
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
    {message, score, rand_int} =
      if String.to_integer(guess) != socket.assigns.rand_int do
        {"Your guess: #{guess}. Wrong. Guess again. ", socket.assigns.score - 1,
         socket.assigns.rand_int}
      else
        {"Your guess: #{guess}. Correct! Guess again. ", socket.assigns.score + 1,
         rand_int(@num_range)}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        rand_int: rand_int
      )
    }
  end
end
