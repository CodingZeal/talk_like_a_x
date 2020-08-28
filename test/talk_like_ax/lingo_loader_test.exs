defmodule TalkLikeAXTest.LingoLoader do
  use ExUnit.Case

  alias TalkLikeAX.LingoLoader

  describe "#load_lingo/1" do
    test "loads default lingo, pirate" do
      {:ok, pirate_lingo} = LingoLoader.load_lingo()
      assert Map.get(pirate_lingo["words"], "admin") == "helm"
    end

    test "handles lingo that doesnt exist" do
      {status, _} = LingoLoader.load_lingo(:blahblah)
      assert status == :error
    end
  end

  describe "#load_lingo_and_extend/2" do
    test "loads default lingo and extends it with passed map" do
      {:ok, pirate_lingo} =
        LingoLoader.load_lingo_and_extend(nil, %{"words" => %{"bloop" => "boop"}})

      assert Map.get(pirate_lingo["words"], "bloop") == "boop"
      assert Map.get(pirate_lingo["words"], "admin") == "helm"
    end
  end
end
