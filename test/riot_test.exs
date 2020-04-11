defmodule RiotTest do
  use ExUnit.Case

  alias Riot.{Parser, Evaluator, Printer}

  doctest Riot

  test "parse eol" do
    assert eval("\n") == "#"
  end

  test "parse eols" do
    assert eval("\n\n\n\n") == "#"
  end

  test "parse empty" do
    assert eval("") == "#"
  end

  test "basic arith" do
    assert eval("2 + 2 * 2") == "6"
  end

  test "parens presedence" do
    assert eval("(2 + 2) * 2") == "8"
  end

  test "simple function application" do
    assert eval("sum 6 7") == "13"
  end

  test "function application associastion" do
    assert eval("(sum 6) 7") == "13"
  end

  test "multiline function application" do
    assert eval("(sum 6\n 7)") == "13"
  end

  test "only assignment" do
    assert eval("x = 42") == "42"
  end

  test "broken assignment" do
    assert eval("x\n = 42") == "42"
  end

  test "singleline sequence of expressions" do
    assert eval("x = 6; 6 * 7") == "42"
  end

  test "multiline sequence of expressions" do
    assert eval("x = 6\nx * 7") == "42"
  end

  test "multiline sequence of expressions with eol around" do
    assert eval("""

    x = 6

    x * 7

    """) == "42"
  end

  test "simple func" do
    assert eval("""
    fact n =
      match n with
        0 -> 1
        _ -> n * fact (n - 1)
      end

    fact 6
    """) == "720"
  end

  defp eval(input) do
    Parser.parse(input)
    |> Evaluator.eval_(Evaluator.builtins())
    |> Printer.print
  end
end
