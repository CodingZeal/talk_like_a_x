defmodule TalkLikeAX do
  alias TalkLikeAX.Translator

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
      {:ok, lingo_map} -> {:ok, Translator.translate_to_lingo(words, lingo_map)}
      {:error, _} -> {:error, :file_not_found}
    end
  end

  def load_lingo(lingo \\ :pirate) do
    path = Path.join(File.cwd!(), "lib/lingos/#{lingo}.yml")
    YamlElixir.read_from_file(path)
  end
end
