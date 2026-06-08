defmodule Ut.Kv do
  def string_to_kv_list(string, separator) do
    string
    |> String.split(separator)
    |> kv_list()
    |> validate()
  end

  def keys_to_kv_list(keys, getter) do
    result = Enum.map(keys, fn key -> {key, getter.(key)} end)
    {:ok, result}
  end

  defp kv_list(kv_string_list) do
    Enum.map(kv_string_list, fn kv_string -> kv(kv_string) end)
  end

  defp kv(kv_string) do
    case String.split(kv_string, "\n", parts: 2) do
      [key, value] ->
        {key, value}

      _ ->
        false
    end
  end

  defp validate(kv_list) do
    if Enum.all?(kv_list) do
      {:ok, kv_list}
    else
      {:error, :bad_format}
    end
  end
end
