defmodule Ut.NumberToWord do
  @moduledoc """
  Credit: Mike Buhot, https://gist.github.com/mbuhot/ba2232750f8e892c4c52142b556c563a
  """

  @max_int 999_999_999_999_999_999_999_999_999_999_999_999

  @spec say(integer) :: String.t
  def say(int) when not is_integer(int), do: {:error, :non_integer}
  def say(int) when int < 0, do: {:error, :negative_integer}
  def say(int) when int > @max_int, do: {:error, :out_of_range}

  def say(int) when is_integer(int) do
    int
    |> say_io()
    |> IO.iodata_to_binary()
  end

  @spec say_io(integer) :: iodata
  defp say_io(0), do: "zero"
  defp say_io(1), do: "one"
  defp say_io(2), do: "two"
  defp say_io(3), do: "three"
  defp say_io(4), do: "four"
  defp say_io(5), do: "five"
  defp say_io(6), do: "six"
  defp say_io(7), do: "seven"
  defp say_io(8), do: "eight"
  defp say_io(9), do: "nine"
  defp say_io(10), do: "ten"
  defp say_io(11), do: "eleven"
  defp say_io(12), do: "twelve"
  defp say_io(13), do: "thirteen"
  defp say_io(14), do: "fourteen"
  defp say_io(15), do: "fifteen"
  defp say_io(16), do: "sixteen"
  defp say_io(17), do: "seventeen"
  defp say_io(18), do: "eighteen"
  defp say_io(19), do: "nineteen"
  defp say_io(20), do: "twenty"
  defp say_io(30), do: "thirty"
  defp say_io(40), do: "forty"
  defp say_io(50), do: "fifty"
  defp say_io(60), do: "sixty"
  defp say_io(70), do: "seventy"
  defp say_io(80), do: "eighty"
  defp say_io(90), do: "ninety"

  defp say_io(n) when n < 100 do
    tens = div(n, 10) * 10
    remainder = rem(n, 10)
    format(tens, "", " ", remainder)
  end

  defp say_io(n) when n < 1000 do
    hundreds = div(n, 100)
    remainder = rem(n, 100)
    format(hundreds, " hundred", separator(remainder), remainder)
  end

  ~w[thousand million billion trillion quadrillion quintillion sextillion septillion octillion nonillion decillion]
  |> Enum.zip(Stream.unfold(1000, fn acc -> {acc, acc * 1000} end))
  |> Enum.each(fn {suffix, m} ->
    defp say_io(n) when n < (unquote(m) * 1000) do
      number = div(n, unquote(m))
      remainder = rem(n, unquote(m))
      format(number, " " <> unquote(suffix), separator(remainder), remainder)
    end
  end)

  @spec separator(integer) :: String.t
  defp separator(remainder) when remainder < 100, do: " and "
  defp separator(_remainder), do: ", "

  @spec format(integer, String.t, String.t, integer) :: iodata
  defp format(number, illion, _separator, 0), do: [say_io(number) | illion]
  defp format(number, illion, separator, remainder), do: [say_io(number), illion, separator | say_io(remainder)]
end
