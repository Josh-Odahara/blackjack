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
    {:noreply, socket
      |> assign(:deck, remaining_deck)
      |> assign(:player_hand, new_hand)
      |> assign(:game_status, (if Blackjack.Game.hand_value(new_hand) > 21, do: :dealer, else: :playing))}
  end

    def handle_event("stand", _params, socket) do
    dealer_hand = socket.assigns.dealer_hand
    deck = socket.assigns.deck
    {new_dealer_hand, _remaining_deck} = dealer_play(dealer_hand, deck)
    player_hand = socket.assigns.player_hand
    {:noreply, socket
      |> assign(:dealer_hand, new_dealer_hand)
      |> assign(:game_status, Blackjack.Game.determine_winner(player_hand, new_dealer_hand) )
    }
  end

end
