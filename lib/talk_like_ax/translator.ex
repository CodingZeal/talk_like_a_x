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
    {leading_puncuation, original_word, trailing_puncuation} = extract_word(word)

    original_word = String.downcase(original_word, :default)
    new_word = Map.get(lingo_map["words"], original_word, original_word)

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

  defp extract_word(word) do
    [[_, leading_punctuation]] = Regex.scan(@leading_punctuation_regex, word)
    [[_, trailing_punctuation]] = Regex.scan(@trailing_punctuation_regex, word)

    leading_length = String.length(leading_punctuation)
    word_length = String.length(word) - leading_length - String.length(trailing_punctuation)
    original_word = String.slice(word, leading_length, word_length)

    {leading_punctuation, original_word, trailing_punctuation}
  end

  defp reconstruct_word(word, leading_puncuation, trailing_puncuation) do
    leading_puncuation <> word <> trailing_puncuation
  end

  defp restore_capitalization(new_word, original_word) do
    cond do
      original_word == String.upcase(original_word) ->
        String.upcase(new_word)

      original_word == String.capitalize(original_word) ->
        [first_letter | other_stuff] = String.graphemes(new_word)
        List.to_string([String.upcase(first_letter), other_stuff])
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
