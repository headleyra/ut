defmodule Ut.KvTest do
  use ExUnit.Case, async: true
  alias Ut.Kv

  setup do
    gmap = %{"key1" => "one", :key2 => ["two"], 3.142 => :pi}
    getter = fn key -> Map.get(gmap, key) end
    smap = %{}
    setter = fn key, value -> Map.put(smap, key, value) end
    %{getter: getter, setter: setter}
  end

  describe "string_to_kv_list/2" do
    test "splits `string` on `separator` and converts the result into a list of key/value pairs" do
      assert Kv.string_to_kv_list("key\nval", ".") == {:ok, [{"key", "val"}]}
      assert Kv.string_to_kv_list("k1\nv1:::k2\nsome\nvalue", ":::") == {:ok, [{"k1", "v1"}, {"k2", "some\nvalue"}]}
      assert Kv.string_to_kv_list("\n---\n", "---") == {:ok, [{"", ""}, {"", ""}]}
      assert Kv.string_to_kv_list("\nvalue..key\n", "..") == {:ok, [{"", "value"}, {"key", ""}]}
    end

    test "errors when keys and/or values can't be found" do
      assert Kv.string_to_kv_list("key-but-no-value", ".") == {:error, :bad_format}
      assert Kv.string_to_kv_list("", "") == {:error, :bad_format}
      assert Kv.string_to_kv_list("   ", "") == {:error, :bad_format}
      assert Kv.string_to_kv_list("\t", "-") == {:error, :bad_format}
    end
  end

  describe "keys_to_kv_list/2" do
    test "uses the `getter` function to expand a list of keys into key/value pairs", do: true
    test "expects `getter` to take a key and return a value", do: true

    test "works", %{getter: getter} do
      assert Kv.keys_to_kv_list(["key1", :key2], getter) == {:ok, [{"key1", "one"}, {:key2, ["two"]}]}
      assert Kv.keys_to_kv_list(["key1"], getter) == {:ok, [{"key1", "one"}]}
      assert Kv.keys_to_kv_list([:key2, "key1"], getter) == {:ok, [{:key2, ["two"]}, {"key1", "one"}]}
      assert Kv.keys_to_kv_list([], getter) == {:ok, []}
      assert Kv.keys_to_kv_list([:no_exist], getter) == {:ok, [{:no_exist, nil}]}
      assert Kv.keys_to_kv_list([3.142, "key1"], getter) == {:ok, [{3.142, :pi}, {"key1", "one"}]}
    end
  end
end
