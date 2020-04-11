defmodule Riot.Evaluator do
  @number_types [:integer, :float]

  def builtins() do
    %{
      "+": make_builtin(&plus/1),
      "*": make_builtin(&mul/1),
      "-": make_builtin(&sub/1),
      "sum": make_builtin(&plus/1)
    }
  end

  def eval(expr, env) do
    case expr do
      {literal, _, _} when literal in [:unit, :integer, :float] ->
        {expr, env}

      {:var, _, _} ->
        {Map.fetch!(env, var_name(expr)), env}

      {:assignment, [var, val], _} ->
        val = eval_(val, env)
        {val, Map.put(env, var_name(var), val)}

      {:application, [expr, args], _} ->
        expr = eval_(expr, env)
        args = eval_list(args, env)
        {riot_apply(expr, args), env}

      {:seq, [exprs], _} ->
        {[last | _], env} = eval_seq_rev(exprs, env)
        {last, env}
    end
  end

  def eval_(expr, env) do
    eval(expr, env) |> elem(0)
  end

  defp eval_list(exprs, env) do
    for expr <- exprs, do: eval_(expr, env)
  end

  defp eval_seq_rev(seq, env) do
    List.foldl(seq, {[], env}, fn(expr, {acc, env}) ->
      {expr, env} = eval(expr, env)
      {[expr | acc], env}
    end)
  end

  defp var_name({:var, [name], _}) do
    name
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

  defp sub([{x_type, [x], _}, {y_type, [y], _}])
      when x_type in @number_types
      and y_type in @number_types do
    type =
      if x_type == :integer and y_type == :integer do
        :integer
      else
        :float
      end
    {type, [x - y], %{}}
  end
end
