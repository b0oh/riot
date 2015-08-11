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

exprs(Str) ->
    {ok, Ts, _} = erl_scan:string(Str),
    {ok, Ast} = erl_parse:parse_exprs(Ts),
    Ast.

term(Str) ->
    {ok, Ts, _} = erl_scan:string(Str),
    {ok, Term} = erl_parse:parse_term(Ts),
    erl_syntax:abstract(Term).

parse_transform(Forms, _) ->
    io:format("~p~n", [Forms]),
    Forms.

erl_file(FileName) ->
    compile:file(FileName, [verbose, report_errors, report_warnings, {parse_transform, riot}]).
