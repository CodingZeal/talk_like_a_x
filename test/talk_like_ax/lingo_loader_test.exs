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
      {:ok, default_lingo} =
        LingoLoader.load_lingo_and_extend(%{"words" => %{"bloop" => "boop"}})

      assert Map.get(default_lingo["words"], "bloop") == "boop"
      assert Map.get(default_lingo["words"], "admin") == "helm"
    end

    test "loads 'surfer' lingo and extends it with passed map" do
      {:ok, surfer_lingo} =
        LingoLoader.load_lingo_and_extend(:surfer, %{"words" => %{"cool" => "tubular"}})

      assert Map.get(surfer_lingo["words"], "bro") == "bruh"
      assert Map.get(surfer_lingo["words"], "cool") == "tubular"
    end
  end
end
