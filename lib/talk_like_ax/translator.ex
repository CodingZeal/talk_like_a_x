defmodule TalkLikeAX.Translator do
  @leading_punctuation_regex ~r/\A([^a-zA-Z]*)/
  @trailing_punctuation_regex ~r/[a-zA-Z]+([^a-zA-Z]*)\Z/

  def translate_to_lingo(words, lingo_map) do
    words
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn word -> translate_word(lingo_map, word) end)
    |> Enum.join(" ")
  end

  defp translate_word(lingo_map, word) do
    [leading_puncuation, pure_word, trailing_puncuation] = deconstruct_word(word)

    pure_word = String.downcase(pure_word, :default)
    new_word = Map.get(lingo_map["words"], pure_word, pure_word)

    translate_gerund(lingo_map, new_word)
    |> restore_capitalization(word)
    |> reconstruct_word(leading_puncuation, trailing_puncuation)
  end

  defp translate_gerund(lingo_map, word) do
    case Map.has_key?(lingo_map, "gerund") do
      true ->
        Map.keys(lingo_map["gerund"])
        |> Enum.find(fn g -> Regex.match?(~r/#{g}\Z/, word) end)
        |> replace_gerund(lingo_map, word)
      _ -> word
    end
  end

  defp deconstruct_word(word) do
    [[_, leading_punctuation]] = Regex.scan(@leading_punctuation_regex, word)
    [[_, trailing_punctuation]] = Regex.scan(@trailing_punctuation_regex, word)

    leading_length = String.length(leading_punctuation)
    word_length = String.length(word) - leading_length - String.length(trailing_punctuation)
    pure_word = String.slice(word, leading_length, word_length)

    [leading_punctuation, pure_word, trailing_punctuation]
  end

  defp reconstruct_word(word, leading_puncuation, trailing_puncuation) do
    leading_puncuation <> word <> trailing_puncuation
  end

  defp restore_capitalization(new_word, word) do
    cond do
      word == String.upcase(word) ->
        String.upcase(new_word)

      word == String.capitalize(word) ->
        String.capitalize(new_word)

      true ->
        new_word
    end
  end

  defp replace_gerund(found_gerund, lingo_map, word) when is_bitstring(found_gerund) do
    replacement_gerund = Map.get(lingo_map["gerund"], found_gerund)
    Regex.replace(~r/#{found_gerund}\Z/, word, replacement_gerund)
  end

  defp replace_gerund(nil, _, word), do: word
end
