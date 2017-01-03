defmodule Riot.Evaluator do
  @number_types [:integer, :float]

  def builtins() do
    %{
      "+": make_builtin(&plus/1),
      "*": make_builtin(&mul/1)
    }
  end

  def eval(expr, env) do
    case expr do
      {literal, _, _} when literal in [:integer, :float] ->
        expr
      {:id, [id], _} ->
        Map.fetch!(env, id)
      {:application, [expr, args], _} ->
        expr = eval(expr, env)
        args = eval_list(args, env)
        riot_apply(expr, args)
    end
  end

  defp eval_list(exprs, env) do
    for expr <- exprs, do: eval(expr, env)
  end

  defp riot_apply(expr, args) do
    case expr do
      {:builtin, [fun], _} ->
        fun.(args)
    end
  end

  defp make_builtin(fun) do
    {:builtin, [fun], %{}}
  end

  defp plus([{x_type, [x], _}, {y_type, [y], _}])
      when x_type in @number_types
      and y_type in @number_types do
    type =
      if x_type == :integer and y_type == :integer do
        :integer
      else
        :float
      end
    {type, [x + y], %{}}
  end

  defp mul([{x_type, [x], _}, {y_type, [y], _}])
      when x_type in @number_types
      and y_type in @number_types do
    type =
      if x_type == :integer and y_type == :integer do
        :integer
      else
        :float
      end
    {type, [x * y], %{}}
  end
end

# alias Riot.{Parser, Evaluator, Printer}
# Parser.parse("2 + 3") |> Evaluator.eval(0) |> Printer.print
