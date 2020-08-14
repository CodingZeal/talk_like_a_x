defmodule TalkLikeAXTest do
  use ExUnit.Case
  doctest TalkLikeAX

  describe "#translate/1" do
    test "fails when a string isnt passed" do
      assert_raise FunctionClauseError, fn ->
        TalkLikeAX.translate(1)
      end
    end

    test "coverts sentence to priate lingo with punctuation" do
      assert TalkLikeAX.translate("hello friend, that's really you're.") ==
               {:ok, "ahoy shipmate, that be verily you be."}
    end
  end

  describe "#translate/2" do
    test "return error & message when file not found" do
      assert TalkLikeAX.translate("hello friend", :nothing_found) == {:error, :file_not_found}
    end
  end

  describe "#load_lingo/1" do
    test "loads default lingo, pirate" do
      {:ok, pirate_lingo} = TalkLikeAX.load_lingo()
      assert Map.get(pirate_lingo, "admin") == "helm"
    end

    test "handles lingo that doesnt exist" do
      {status, message} = TalkLikeAX.load_lingo(:blahblah)
      assert status == :error
    end
  end
end
