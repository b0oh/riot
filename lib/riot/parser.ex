defmodule Riot.Parser do
  def parse(str) do
    {:ok, tokens, _} = str |> to_charlist |> :riot_lexer.string
    {:ok, list} = :riot_parser.parse(tokens)
    list
  end
end
