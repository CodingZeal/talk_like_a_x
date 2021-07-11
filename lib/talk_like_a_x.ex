defmodule TalkLikeAX do
  alias TalkLikeAX.Translator
  alias TalkLikeAX.LingoLoader

  @moduledoc """
  TalkLikeAX provides you the ability convert a string of text into
  a different lingo (AKA language).
  """

  @doc """
  Returns a tuple with the string translated to default lingo pirate.

  ## Parameters

    - words: String of the words you would like tranlsated to a lingo

  ## Examples

      iex> TalkLikeAX.translate("hello friend")
      { :ok, "ahoy matey" }

      iex> TalkLikeAX.translate("")
      { :ok, "" }
  """
  def translate(words) when is_bitstring(words), do: translate(words, :pirate)

  @doc """
  Returns a tuple with the string transalated to your desired lingo.

  ## Parameters

    - words: String of the words you would like tranlsated to a lingo
    - lingo: Atom for lingo you would like to translate to. :pirate is the only language with a robust dictionary of words.

  ## Examples

      iex> TalkLikeAX.translate("hello friend", :pirate)
      { :ok, "ahoy matey" }


      iex> TalkLikeAX.translate("Hello friend, doctorargus", :doesnt_exist)
      { :error, :file_not_found }
  """
  def translate(words, lingo \\ :pirate) when is_bitstring(words) do
    case LingoLoader.load_lingo(lingo) do
      {:ok, lingo_map} -> {:ok, Translator.translate_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end

  @doc """
  Returns a tuple with the string transalated to your desired lingo.

  ## Parameters

    - words: String of the words you would like tranlsated to a lingo
    - lingo: Atom for lingo you would like to translate to. :pirate is the only language with a robust dictionary of words.
    - extended_lingo: A map containing two properties "words" & "gerunds" to add additional custom words to use in the translation. Both "words" & "gerunds" must be a map of "word" => "translated_word"

  ## Examples

      iex> TalkLikeAX.translate("Hello friend, doctorargus", :pirate, %{ "words" => %{ "doctorargus" => "Doc Arrrrgus" } })
      { :ok, "Ahoy matey, Doc Arrrrgus" }
  """
  def translate(words, lingo, extended_lingo) when is_map(extended_lingo) do
    case LingoLoader.load_lingo_and_extend(lingo, extended_lingo) do
      {:ok, lingo_map} -> {:ok, Translator.translate_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end
end
