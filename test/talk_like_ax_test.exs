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
      assert TalkLikeAX.translate("hello friend, that's really nice hat you got there friend.") ==
               {:ok, "ahoy shipmate, that be verily nice hat ye got there shipmate."}
    end

    test "does not downcase words when converting to lingo" do
      assert TalkLikeAX.translate("Hello, how's it going over there at ZEAL?") ==
               {:ok, "Ahoy, how's it goin' o'er there at ZEAL?"}
    end
  end

  describe "#translate/2" do
    test "return error & message when file not found" do
      assert TalkLikeAX.translate("hello friend", :nothing_found) == {:error, :file_not_found}
    end
  end
end
