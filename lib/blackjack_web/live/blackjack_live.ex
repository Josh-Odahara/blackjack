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

  end
end
