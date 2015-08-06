-module(riot_gen).
-export([forms/2]).

exports(Toplevels) ->
    [{Name, 0} || {toplevel, {symbol, _, Name}, _} <- Toplevels].

forms(Toplevels, Mod) ->
    Exports = exports(Toplevels),
    Forms = [toplevel(Toplevel) || Toplevel <- Toplevels],
    Ast = [{attribute, 0, module, Mod}, {attribute, 0, export, Exports} | Forms],
    {ok, Ast}.

toplevel({toplevel, {symbol, L, Name}, Body}) ->
    {function, L, Name, 0, [{clause, L, [], [], [form(Body)]}]}.

form({integer, _, _} = Expr) -> Expr;
form({float, _, _} = Expr) -> Expr;
form({string, _, _} = Expr) -> Expr.
