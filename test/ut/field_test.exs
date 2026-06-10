defmodule Ut.FieldTest do
  use ExUnit.Case, async: true
  alias Ut.Field

  describe "join/4" do
    test "separates, selects and joins, `string`", do: true
    test "uses 'select specs' as defined in `Ut.Select`", do: true

    test "works" do
      assert Field.join("foo.bar.biz", "1,3", ".", "-") == {:ok, "foo-biz"}
      assert Field.join("cash; money; dosh", "100,3,2", "; ", "@") == {:ok, "@dosh@money"}
    end

    test "works with URI-encoded separators and joiners" do
      assert Field.join("one\ntwo\nthree", "1-3,2,1", "%0a", "%20") == {:ok, "one two three two one"}
    end

    test "errors with a bad 'select spec'" do
      assert Field.join("integers.only.please", "foo", ".", "-") == {:error, :bad_spec}
    end
  end
end
