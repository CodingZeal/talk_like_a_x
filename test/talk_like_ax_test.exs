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

  describe "#load_lingo/1" do
    test "loads default lingo, pirate" do
      {:ok, pirate_lingo} = TalkLikeAX.load_lingo()
      assert Map.get(pirate_lingo["words"], "admin") == "helm"
    end

    test "handles lingo that doesnt exist" do
      {status, _ } = TalkLikeAX.load_lingo(:blahblah)
      assert status == :error
    end
  end

  describe "#deconstruct_word/1" do
    test "return list containg leading punc, word, and trailing punc" do
      assert TalkLikeAX.deconstruct_word(",this.out.") == [",", "this.out", "."]
      assert TalkLikeAX.deconstruct_word(",,,,this.out......") == [",,,,", "this.out", "......"]
    end
  end

  describe "#convert_word/2" do
    test "Converts the word 'friend' to 'shipmate'" do
      {:ok, pirate_lingo} = TalkLikeAX.load_lingo()
      assert TalkLikeAX.convert_word(pirate_lingo, "friend") == "shipmate"
    end

    test "Converts the word with punctuation 'hello!' to 'ahoy!'" do
      {:ok, pirate_lingo} = TalkLikeAX.load_lingo()
      assert TalkLikeAX.convert_word(pirate_lingo, "hello!") == "ahoy!"
    end

    test "Converts gerand words to lingos style of word" do
      {:ok, pirate_lingo} = TalkLikeAX.load_lingo()
      assert TalkLikeAX.convert_word(pirate_lingo, "singing") == "singin'"
      assert TalkLikeAX.convert_word(pirate_lingo, "smellings") == "smellin's"
    end
  end
end
