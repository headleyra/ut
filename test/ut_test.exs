defmodule UtTest do
  use ExUnit.Case
  doctest Ut

  test "greets the world" do
    assert Ut.hello() == :world
  end
end
