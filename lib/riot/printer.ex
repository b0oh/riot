defmodule Riot.Printer do
  def print(expr) do
    case expr do
      {:integer, [value], _} ->
        Integer.to_string(value)
      {:float, [value], _} ->
        Float.to_string(value)
      {:unit, _, _} ->
        "#"
    end
  end
end
