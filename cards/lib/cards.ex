defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling deck of cards.
  """

  @doc """
    Returns a list of deck of cards
  """
  def create_deck do
    values = ["Ace","Two","Three","Four","Five"]
    suits = ["Clubs","Hearts","Hearts","Spade","Hearts"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determine whether the card is present in the deck or not.
  ## Examples:
      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck,"Ace of Clubs")
      iex> true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides the deck into a hand and remainder of the deck
    The 'hand_size' argument indicates how many to be distributed.

  ## Examples:
      iex> deck = Cards.create_deck()
      iex> {hand, _rest} = Cards.deal(deck,5)
      iex> hand
      ["Ace of Clubs", "Two of Clubs", "Three of Clubs", "Four of Clubs",
      "Five of Clubs"]
  """
  def deal(deck, hand) do
    Enum.split(deck, hand)
  end

  def save_deck(deck,filename) do
    binary = :erlang.term_to_binary(deck)
    File.write!(filename,binary)
  end

  def load_deck(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        IO.puts("File read successfully!")
        :erlang.binary_to_term binary
      {:error, _reason} -> IO.puts("File doesnt exist!")
    end
  end

  def create_and_shuffle(hand_size) do
    {myhand, rest} = create_deck() |> shuffle() |> deal(hand_size)
    {myhand, rest}
  end
end
