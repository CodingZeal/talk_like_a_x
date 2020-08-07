defmodule TalkLikeAX do
  @moduledoc """
  Documentation for `TalkLikeAX`.
  """

  @doc """

  ## Examples

      iex> TalkLikeAX.translate("hello friend")
      { :ok, "ahoy shipmate" }

  """
  def translate(words, lingo \\ :pirate) when is_bitstring(words) do
    case load_lingo(lingo) do
      { :ok, lingo_map } -> { :ok, convert_lingo(words, lingo_map) }
      { :error, _ } -> { :error, :file_not_found }
    end
  end

  def convert_lingo(words, lingo_map) do
    words
    |> String.downcase(:default)
    |> String.split(" ")
    |> Enum.map(fn word -> Map.get(lingo_map, word, word) end)
    |> Enum.join(" ")
  end

  def extract_punctuation(word) do
    String.split(word, ~r{\A([^a-zA-Z]*)}, trim: true)
  end

  def load_lingo(lingo \\ :pirate) do
    path = Path.join(File.cwd!(), "lib/lingos/#{lingo}.yml")
    YamlElixir.read_from_file(path)
  end
end
