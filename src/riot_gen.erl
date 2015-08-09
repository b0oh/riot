-module(riot_gen).
-export([forms/1]).

forms({module, {id, L, Module}, Toplevels}) ->
    Exports = exports(Toplevels),
    Forms = [toplevel(Toplevel) || Toplevel <- Toplevels],
    Ast = [{attribute, L, module, Module}, {attribute, L, export, Exports} | Forms],
    {ok, Ast}.

exports(Bindings) ->
    [{Name, args_length(Args)} || {binding, {symbol, _, Name}, Args, _} <- Bindings].

args_length([{unit, _}]) -> 0;
args_length(Args) -> length(Args).

toplevel({binding, {symbol, L, Name}, Args, Body}) ->
    {function, L, Name, args_length(Args),
     [clause(L, Args, Body)]}.

form({integer, _, _} = Expr) -> Expr;
form({float, _, _} = Expr) -> Expr;
form({string, _, _} = Expr) -> Expr;
form({list, L, List}) -> list_form(L, List);
form({symbol, L, Symbol}) -> {var, L, Symbol};
form({unit, L}) -> {atom, L, unit};
form({fn, L, Args, Body}) ->
    {'fun', L, {clauses, [clause(L, Args, Body)]}};
form({app, Applyable, Args}) ->
    {call, line(Applyable), applyable(Applyable), [form(Arg) || Arg <- Args]}.

clause(L, Args, Body) ->
    {clause, L, [{var, ArgL, Symbol} || {symbol, ArgL, Symbol} <- Args], [], [form(Body)]}.

list_form(L, []) -> {nil, L};
list_form(_, [H | T]) ->
    L = line(H),
    {cons, L, form(H), list_form(L, T)}.

applyable({symbol, L, Symbol}) -> {atom, L, Symbol};
applyable({remote, L, {Module, Fun}}) -> {remote, L, {atom, L, Module},
                                                     {atom, L, Fun}}.

line(T) when is_tuple(T) -> element(2, T).
