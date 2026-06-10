defmodule Ut.NumberToWordTest do
  use ExUnit.Case, async: true
  alias Ut.NumberToWord

  describe "say/1" do
    test "converts an integer into its word equivalent" do
      assert NumberToWord.say(0) == "zero"
      assert NumberToWord.say(1) == "one"
      assert NumberToWord.say(19) == "nineteen"
      assert NumberToWord.say(2_000_000_000_005) == "two trillion and five"
    end

    test "errors for negative integers" do
      assert NumberToWord.say(-5) == {:error, :negative_integer}
    end

    test "errors for non-integers" do
      assert NumberToWord.say("21") == {:error, :non_integer}
      assert NumberToWord.say({5}) == {:error, :non_integer}
      assert NumberToWord.say([1]) == {:error, :non_integer}
    end
  end
end
