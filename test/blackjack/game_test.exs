defmodule Blackjack.GameTest do
  use ExUnit.Case
  alias Blackjack.Game

test "deal_card/1 deals a card to a player" do
  deck = Game.new_deck()
  {card, remaining_deck} = Game.deal_card(deck)
  {_suit, _rank} = card
  assert length(remaining_deck) == 51
end

test "new_deck/0 creates a new deck" do
  deck = Game.new_deck()
  assert length(deck) == 52
end

test "new_deck/0 checks for no duplicate cards" do
  deck = Game.new_deck()
  assert length(Enum.uniq(deck)) == length(deck)
end

test "shuffle_deck/1 shuffles cards" do
  deck = Game.new_deck()
  shuffled = Game.shuffle_deck(deck)
  assert length(shuffled) == 52
end

test "shuffle_deck/1 checks for 52 cards and the sorted version match" do
  deck = Game.new_deck()
  shuffled = Game.shuffle_deck(deck)
  assert length(shuffled) == 52
  assert Enum.sort(shuffled) == Enum.sort(deck)
end

end
