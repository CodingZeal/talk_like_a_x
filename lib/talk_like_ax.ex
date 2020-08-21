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
      {:ok, lingo_map} -> {:ok, convert_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end

  def convert_to_lingo(words, lingo_map) do
    words
    |> String.downcase(:default)
    |> String.split(" ")
    |> Enum.map(fn word -> convert_word(lingo_map, word) end)
    |> Enum.join(" ")
  end

  def convert_word(lingo_map, word) do
    [leading_puncuation, pure_word, trailing_puncuation] = extract_punctuation(word)
    new_word = Map.get(lingo_map["words"], pure_word, pure_word)

    new_word = convert_gerund(lingo_map, new_word)

    leading_puncuation <> new_word <> trailing_puncuation
  end

  def convert_gerund(lingo_map, word) do
    gerunds = Map.keys(lingo_map["gerund"])
    if found_gerund = Enum.find(gerunds, fn g -> Regex.match?(~r/#{g}\Z/, word) end ) do
      replacement_gerund = Map.get(lingo_map["gerund"], found_gerund)
      Regex.replace ~r/#{found_gerund}\Z/, word, replacement_gerund
    else
      word
    end
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
