defmodule Ut.SelectTest do
  use ExUnit.Case, async: true
  alias Ut.Select

  describe "list/1" do
    test "converts a 'select spec' into a zero-indexed list" do
      assert Select.list("1") == [0]
      assert Select.list("2,5") == [1, 4]
      assert Select.list("2-4,8") == [[1, 2, 3], 7]
      assert Select.list("11,11-15,98") == [10, [10, 11, 12, 13, 14], 97]
      assert Select.list("1-3,8-5") == [[0, 1, 2], [7, 6, 5, 4]]
      assert Select.list("8-8") == [[7]]
    end

    test "errors with zeroes" do
      assert Select.list("0") == :error
      assert Select.list("0-3") == :error
      assert Select.list("7,0") == :error
    end

    test "errors with negatives" do
      assert Select.list("1-3,-7-1") == :error
      assert Select.list("-3") == :error
      assert Select.list("-1-3") == :error
    end

    test "errors with non-integers" do
      assert Select.list("3.1") == :error
      assert Select.list("1 two") == :error
      assert Select.list("foo bar") == :error
      assert Select.list("") == :error
      assert Select.list("\t") == :error
      assert Select.list(" \n") == :error
    end
  end
end
