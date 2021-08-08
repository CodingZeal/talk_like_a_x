defmodule TalkLikeAXTest.Translator do
  use ExUnit.Case
  alias TalkLikeAX.Translator

  describe "#translate_to_lingo/2" do
    setup do
      custom_lingo = %{
        "gerund" => %{
          "ing" => "in'",
          "ings" => "in's"
        },
        "words" => %{
          "friend" => "shipmate",
          "hello" => "ahoy",
          "you" => "yee",
          "day" => "sun up time"
        }
      }

      custom_without_gerund = %{
        "words" => %{
          "friend" => "shipmate",
          "hello" => "ahoy",
          "you" => "yee",
          "day" => "sun up time"
        }
      }

      {:ok, lingo: custom_lingo, lingo_without_gerund: custom_without_gerund}
    end

    test "Converts sentence to lingo", context do
      assert Translator.translate_to_lingo("Hello there friend I hope you well", context[:lingo]) ==
               "Ahoy there shipmate I hope yee well"
    end

    test "Handles sentences containing just numbers", context do
      assert Translator.translate_to_lingo("222,000", context[:lingo]) ==
               "222,000"
    end

    test "Converts sentence to lingo without any gerunds", context do
      assert Translator.translate_to_lingo("Hello there friend I hope you well", context[:lingo_without_gerund]) ==
               "Ahoy there shipmate I hope yee well"
    end

    test "Converts sentence with punctuation marks properly", context do
      assert Translator.translate_to_lingo(
               "Hello, there friend I hope your day is good.",
               context[:lingo]
             ) == "Ahoy, there shipmate I hope your sun up time is good."
    end

    test "Converts sentence with leading and trailing whitespace properly", context do
      assert Translator.translate_to_lingo(" Hello there ", context[:lingo]) == "Ahoy there"
    end

    test "Converts gerand words to lingos style of word", context do
      assert Translator.translate_to_lingo("singing", context[:lingo]) == "singin'"
      assert Translator.translate_to_lingo("smellings", context[:lingo]) == "smellin's"
    end

    test "can handle non-word characters characters", context do
      assert Translator.translate_to_lingo("***", context[:lingo]) == "***"
      assert Translator.translate_to_lingo("***&&$$", context[:lingo]) == "***&&$$"
    end
  end
end
