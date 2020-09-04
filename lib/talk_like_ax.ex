defmodule TalkLikeAX do
  alias TalkLikeAX.Translator
  alias TalkLikeAX.LingoLoader

  @moduledoc """
  Documentation for `TalkLikeAX`.
  """

  @doc """

  ## Examples

      iex> TalkLikeAX.translate("hello friend")
      { :ok, "ahoy shipmate" }

      iex> TalkLikeAX.translate("hello friend", :pirate)
      { :ok, "ahoy shipmate" }

      iex> TalkLikeAX.translate("Hello friend, doctorargus", :pirate, %{ "words" => %{ "doctorargus" => "DocArrrrgus" } })
      { :ok, "Ahoy shipmate, DocArrrrgus" }
  """
  def translate(words, lingo \\ :pirate) when is_bitstring(words) do
    case LingoLoader.load_lingo(lingo) do
      {:ok, lingo_map} -> {:ok, Translator.translate_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end

  def translate(words, lingo, extended_lingo) when is_map(extended_lingo) do
    case LingoLoader.load_lingo_and_extend(lingo, extended_lingo) do
      {:ok, lingo_map} -> {:ok, Translator.translate_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end
end
