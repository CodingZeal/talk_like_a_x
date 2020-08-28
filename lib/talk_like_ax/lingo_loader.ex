defmodule TalkLikeAX.LingoLoader do
  def load_lingo(lingo \\ :pirate) do
    path = Path.join(File.cwd!(), "lib/lingos/#{lingo}.yml")
    YamlElixir.read_from_file(path)
  end

  def load_lingo_and_extend(lingo \\ :pirate, extended_lingo) do
    case load_lingo() do
      {:ok, lingo_map} -> {:ok, DeepMerge.deep_merge(lingo_map, extended_lingo)}
      {:error, _} = result -> result
    end
  end
end
