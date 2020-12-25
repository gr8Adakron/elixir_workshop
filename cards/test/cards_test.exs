defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck must create 20 cards" do
    deck_length = length(Cards.create_deck)
    assert deck_length == 25
  end

  test "Shuffling really works" do
    deck = Cards.create_deck
    refute deck == Cards.shuffle(deck)
  end
end
