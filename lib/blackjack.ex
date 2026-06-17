defmodule Blackjack do
  @moduledoc """
  Blackjack keeps the contexts that define your domain
  """

  defp dealer_play(dealer_hand, deck) do
    if Blackjack.Game.hand_value(dealer_hand) < 17 do
      {card, remaining_deck} = Blackjack.Game.deal_card(deck)
      new_hand = [card | dealer_hand]
      dealer_play(new_hand, remaining_deck)
    else
      {dealer_hand, deck}
    end
  end
end
