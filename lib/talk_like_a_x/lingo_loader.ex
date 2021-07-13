defmodule TalkLikeAX.LingoLoader do
  @moduledoc false

  def load_lingo(lingo \\ :pirate) do
    case lingo do
      :pirate -> {:ok, TalkLikeAX.Lingos.Pirate.map() }
      :surfer -> {:ok, TalkLikeAX.Lingos.Surfer.map() }
      _ -> {:error, :lingo_doesnt_exist}
    end
  end

  def load_lingo_and_extend(extended_lingo) when is_map(extended_lingo) do
    load_lingo_and_extend(:pirate, extended_lingo)
  end

  def load_lingo_and_extend(lingo, extended_lingo) do
    case load_lingo(lingo) do
      {:ok, lingo_map} -> {:ok, DeepMerge.deep_merge(lingo_map, extended_lingo)}
      {:error, _} = result -> result
    end
  end
end
