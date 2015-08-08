-module(riot_compiler).
-export([file/2]).
-export([tokenize/1, parse/1, gen/1, compile/1, save/1]).

-record(st, {source, target, module, data, compiled, warns = [], errors = []}).

file(Source, Target) ->
    St = do([tokenize, parse, gen, compile, save], #st{source = Source, target = Target}),
    return(St).

has_errors(#st{errors = []}) -> false;
has_errors(#st{})            -> true.

format_errors(_,        []) -> [];
format_errors(Filename, Es) -> [{Filename, lists:reverse(Es)}].

return(#st{source = Source, module = Mod, warns = Ws, errors = Es} = St) ->
    Filename = filename:basename(Source),
    Warns = format_errors(Filename, Ws),
    Errors = format_errors(Filename, Es),
    case has_errors(St) of
        true  -> {error, Errors, Warns};
        false -> {ok, Mod, Warns}
    end.

do([], St) -> St;
do([Action | As], St0) ->
    St1 = apply(?MODULE, Action, [St0]),
    case has_errors(St1) of
        true  -> St1;
        false -> do(As, St1)
    end.

tokenize(#st{source = Source, errors = Es} = St) ->
    case file:open(Source, [read]) of
        {ok, File} ->
            case tokenize_loop(File, []) of
                {ok, Tokens} ->
                    file:close(File),
                    St#st{data = lists:reverse(Tokens)};
                {error, Reason} ->
                    St#st{errors = [Reason | Es]}
            end;
        {error, Reason} ->
            St#st{errors = [Reason | Es]}
    end.

tokenize_loop(File, Acc) ->
    case io:request(File, {get_until, prompt, riot_lexer, token, [1]}) of
        {ok, Token, _EndLine} ->
            tokenize_loop(File, [Token | Acc]);
        {error, Reason} ->
            {error, Reason};
        {eof, _} ->
            {ok, Acc}
    end.

parse(#st{data = Tokens, errors = Es} = St) ->
    case riot_parser:parse(Tokens) of
        {ok, Exprs} ->
            St#st{data = Exprs};
        {error, Reason} ->
            St#st{errors = [Reason | Es]}
    end.

gen(#st{data = Exprs, errors = Es} = St) ->
    case riot_gen:forms(Exprs) of
        {ok, Forms} ->
            St#st{data = Forms};
        {error, Reason} ->
            St#st{errors = [Reason | Es]}
    end.

compile(#st{data = Forms, warns = Ws, errors = Es} = St) ->
    case compile:forms(Forms, [return]) of
        {ok, Mod, Beam, []} ->
            St#st{data = Beam, module = Mod};
        {ok, Mod, Beam, [{_, Warns}]} ->
            St#st{data = Beam, module = Mod, warns = lists:reverse(Warns, Ws)};
        {error, [{_, Errors}], []} ->
            St#st{errors = lists:reverse(Errors, Es)};
        {error, [{_, Errors}], [{_, Warns}]} ->
            St#st{errors = lists:reverse(Errors, Es), warns = lists:reverse(Warns, Ws)}
    end.

save(#st{target = Target, data = Data, errors = Es} = St) ->
    case file:write_file(Target, Data) of
        ok -> St;
        {error, Error} -> St#st{errors = [Error | Es]}
    end.
