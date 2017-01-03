defmodule RiotTest do
  use ExUnit.Case

  alias Riot.{Parser, Evaluator, Printer}

  doctest Riot

  test "basic arith" do
    assert eval("2 + 2 * 2") == "6"
  end

  test "parens presedence" do
    assert eval("(2 + 2) * 2") == "8"
  end

  defp eval(input) do
    Parser.parse(input)
    |> Evaluator.eval(Evaluator.builtins())
    |> Printer.print
  end
end
