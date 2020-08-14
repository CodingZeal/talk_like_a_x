defmodule TalkLikeAX do
  @leading_punctuation_regex ~r/\A([^a-zA-Z]*)/
  @trailing_punctuation_regex ~r/[a-zA-Z]+([^a-zA-Z]*)\Z/

  @moduledoc """
  Documentation for `TalkLikeAX`.
  """

  @doc """

  ## Examples

      iex> TalkLikeAX.translate("hello friend")
      { :ok, "ahoy shipmate" }

      iex> TalkLikeAX.translate("hello friend", :pirate)
      { :ok, "ahoy shipmate" }

  """
  def translate(words, lingo \\ :pirate) when is_bitstring(words) do
    case load_lingo(lingo) do
      {:ok, lingo_map} -> {:ok, convert_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end

  def convert_lingo(words, lingo_map) do
    words
    |> String.downcase(:default)
    |> String.split(" ")
    |> Enum.map(fn word -> Map.get(lingo_map, word, word) end)
    |> Enum.join(" ")
  end

  @spec extract_punctuation(any) :: nil
  def extract_punctuation(word) do
    [[ _, leading_punctuation ]] = Regex.scan @leading_punctuation_regex, word
    [[ _, trailing_punctuation ]] = Regex.scan @trailing_punctuation_regex, word

    leading_length = String.length(leading_punctuation)

    word_length = String.length(word) - leading_length - String.length(trailing_punctuation)

    pure_word = String.slice(word, leading_length, word_length)

    [ leading_punctuation, pure_word, trailing_punctuation]
  end

  def load_lingo(lingo \\ :pirate) do
    path = Path.join(File.cwd!(), "lib/lingos/#{lingo}.yml")
    YamlElixir.read_from_file(path)
  end
end
