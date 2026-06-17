defmodule BlackjackWeb.BlackjackLive do
  use BlackjackWeb, :live_view

  def mount(_params, _session, socket) do
    deck = Blackjack.Game.new_deck() |> Blackjack.Game.shuffle_deck()
    {player_hand, remaining_deck} = Blackjack.Game.deal_initial_hand(deck)
    {dealer_hand, final_deck} = Blackjack.Game.deal_initial_hand(remaining_deck)

    {:ok,
     socket
     |> assign(:deck, final_deck)
     |> assign(:player_hand, player_hand)
     |> assign(:dealer_hand, dealer_hand)
     |> assign(:game_status, :playing)}
  end

  def handle_event("new_game", _params, socket) do
    deck = Blackjack.Game.new_deck() |> Blackjack.Game.shuffle_deck()
    {player_hand, remaining_deck} = Blackjack.Game.deal_initial_hand(deck)
    {dealer_hand, final_deck} = Blackjack.Game.deal_initial_hand(remaining_deck)

    {:noreply,
     socket
     |> assign(:deck, final_deck)
     |> assign(:player_hand, player_hand)
     |> assign(:dealer_hand, dealer_hand)
     |> assign(:game_status, :playing)}
  end

  def handle_event("hit", _params, socket) do
    deck = socket.assigns.deck
    player_hand = socket.assigns.player_hand
    {card, remaining_deck} = Blackjack.Game.deal_card(deck)
    new_hand = [card | player_hand]

    {:noreply,
     socket
     |> assign(:deck, remaining_deck)
     |> assign(:player_hand, new_hand)
     |> assign(
       :game_status,
       if(Blackjack.Game.hand_value(new_hand) > 21, do: :dealer, else: :playing)
     )}
  end

  def handle_event("stand", _params, socket) do
    dealer_hand = socket.assigns.dealer_hand
    deck = socket.assigns.deck
    {new_dealer_hand, _remaining_deck} = dealer_play(dealer_hand, deck)
    player_hand = socket.assigns.player_hand

    {:noreply,
     socket
     |> assign(:dealer_hand, new_dealer_hand)
     |> assign(:game_status, Blackjack.Game.determine_winner(player_hand, new_dealer_hand))}
  end

  defp dealer_play(dealer_hand, deck) do
    if Blackjack.Game.hand_value(dealer_hand) < 17 do
      {card, remaining_deck} = Blackjack.Game.deal_card(deck)
      new_hand = [card | dealer_hand]
      dealer_play(new_hand, remaining_deck)
    else
      {dealer_hand, deck}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1>Blackjack</h1>
      </div>

      <div>
        <h1>
          Dealer: {Blackjack.Game.hand_value(@dealer_hand)}
          <%= for card <- @dealer_hand do %>
            <span>{Blackjack.Game.card_to_string(card)}</span>
          <% end %>
        </h1>
      </div>

      <div>
        <h1>
          Player: {Blackjack.Game.hand_value(@player_hand)}
          <%= for card <- @player_hand do %>
            <span>{Blackjack.Game.card_to_string(card)}</span>
          <% end %>
        </h1>
        <button phx-click="hit">Hit Me</button>
        <button phx-click="stand">Stand</button>
      </div>

      <div>
        <button phx-click="new_game">New Game</button>
      </div>

      <div :if={@game_status == :dealer}>
        <h1>Dealer wins</h1>
      </div>

      <div :if={@game_status == :player}>
        <h1>Player wins</h1>
      </div>

      <div :if={@game_status == :tie}>
        <h1>It's a tie</h1>
      </div>
    </div>
    """
  end
end
