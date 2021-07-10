defmodule TalkLikeAXTest do
  use ExUnit.Case
  doctest TalkLikeAX

  describe "#translate/1" do
    test "fails when a string isnt passed" do
      assert_raise FunctionClauseError, fn ->
        TalkLikeAX.translate(1)
      end
    end
  end
end
