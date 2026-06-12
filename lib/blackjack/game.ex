defmodule Blackjack.Game do
  @moduledoc """
  Blackjack keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def new_deck() do
    suits = [:heart, :diamond, :spade, :club]
    ranks =[2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    for suit <- suits, rank <- ranks do
      {suit, rank}
    end
  end

  def shuffle_deck(deck) do
    Enum.shuffle(deck)
  end

  def deal_card(deck) do
    [head | tail] = deck
    {head, tail}
  end

  def card_value({_suit, 2}), do: 2
  def card_value({_suit, 3}), do: 3
  def card_value({_suit, 4}), do: 4
  def card_value({_suit, 5}), do: 5
  def card_value({_suit, 6}), do: 6
  def card_value({_suit, 7}), do: 7
  def card_value({_suit, 8}), do: 8
  def card_value({_suit, 9}), do: 9
  def card_value({_suit, 10}), do: 10
  def card_value({_suit, :jack}), do: 10
  def card_value({_suit, :queen}), do: 10
  def card_value({_suit, :king}), do: 10
  def card_value({_suit, :ace}), do: 11

  def hand_value(hand) do
    total = hand
    |> Enum.map(&card_value/1)
    |> Enum.sum()

  if total > 21 and Enum.any?(hand, fn {_suit, rank} -> rank == :ace end) do
    total - 10
  else
    total
  end
  end

  def deal_initial_hand(deck) do
    {card1, remaining_deck} = deal_card(deck)
    {card2, final_deck} = deal_card(remaining_deck)
    {[card1, card2], final_deck}
  end

  def determine_winner(player_score, dealer_score) do
    player_score = hand_value(player_hand)
    dealer_score = hand_value(dealer_score)

    cond do
      player_score > 21 -> :dealer
      dealer_score > 21 -> :player
      player_score < dealer_score -> :dealer
      dealer_score < player_score -> :player
      player_score == dealer_score -> :tie
      true -> :new_game
    end
  end

end
