-module(riot_gen).
-export([forms/1]).
-export([integer_form/2, float_form/2, string_form/2, symbol_form/2, unit_form/1,
         list_form/2, let_form/3, fn_form/3, app_form/3]).

forms({module, [{id, [Module], _}, Toplevels], #{line := L}}) ->
    Exports = exports(Toplevels),
    Forms = [toplevel(Toplevel) || Toplevel <- Toplevels],
    Ast = [{attribute, L, module, Module}, {attribute, L, export, Exports} | Forms],
    {ok, Ast}.

exports(Bindings) ->
    [{Name, args_length(Args)} || {binding, [{symbol, [Name], _}, Args, _], _} <- Bindings].

args_length([{unit, _, _}]) -> 0;
args_length(Args) -> length(Args).

toplevel({binding, [{symbol, [Name], _}, Args, Body], #{line := L}}) ->
    {function, L, Name, args_length(Args),
     [clause(L, Args, Body)]}.

form({Name, Args, Meta}) ->
    Fun = list_to_atom(atom_to_list(Name) ++ "_form"),
    apply(?MODULE, Fun, Args ++ [Meta]).

integer_form(Integer, #{line := L}) ->
    {integer, L, Integer}.

float_form(Float, #{line := L}) ->
    {float, L, Float}.

string_form(String, #{line := L}) ->
    {string, L, String}.

symbol_form(Symbol, #{line := L}) ->
    {var, L, Symbol}.

unit_form(#{line := L}) ->
    {atom, L, unit}.

list_form([], #{line := L}) ->
    {nil, L};
list_form([{_, _, #{line := L}} = H | T], Meta) ->
    {cons, L, form(H), list_form(T, Meta)}.

let_form(Bindings, Body, _) ->
    matches(Bindings) ++ [form(Body)].

fn_form(Args, Body, #{line := L}) ->
    {'fun', L, {clauses, [clause(L, Args, Body)]}}.

app_form({_, _, #{line := L}} = Applyable, Args, _) ->
    {call, L, applyable(Applyable), args(Args)}.

clause(L, Args, Body0) ->
    Body1 =
        case form(Body0) of
            [_|_] = Exprs ->
                Exprs;
            Expr ->
                [Expr]
        end,
    {clause, L, args(Args), [], Body1}.

args(Args) ->
    [form(Arg) || {Tag, _, _} = Arg <- Args, Tag /= unit].

matches([]) ->
    [];
matches([{{_, _, #{line := L}} = Left, Right} | Bindings]) ->
    [{match, L, form(Left), form(Right)} | matches(Bindings)].

applyable({symbol,[Symbol], #{line := L}}) ->
    {atom, L, Symbol};
applyable({remote, [{Module, Fun}], #{line := L}}) ->
    {remote, L, {atom, L, Module},
                {atom, L, Fun}}.
