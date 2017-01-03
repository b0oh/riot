defmodule Riot.Parser do
  @spec parse(binary) :: list
  def parse(str) do
    {:ok, tokens, _} = str |> to_char_list |> :riot_lexer.string
    {:ok, list} = :riot_parser.parse(tokens)
    list
  end
end
