-module(riot).
-compile(export_all).

string(Str) ->
    {ok, Tokens, _} = riot_lexer:string(Str),
    gen(Tokens).

file(FileName) ->
    {ok, File} = file:open(FileName, [read]),
    Tokens = lists:reverse(loop(File, [])),
    file:close(File),
    gen(Tokens).

loop(File, Acc) ->
    case io:request(File, {get_until, prompt, riot_lexer, token, [1]}) of
        {ok, Token, _EndLine} ->
            loop(File, [Token | Acc]);
        {error, token} ->
            exit(scanning_error);
        {eof, _} ->
            Acc
    end.

gen(Tokens) ->
    io:format("TOKENS~n~p~n", [Tokens]),
    {ok, Ast} = riot_parser:parse(Tokens),
    io:format("AST~n~p~n", [Ast]),
    {ok, Forms} = riot_gen:forms(Ast),
    Forms.
