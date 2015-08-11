Definitions.

Digit   = [0-9]
Upper   = [A-Z]
Lower   = [a-z]
Alpha   = ({Upper}|{Lower})
Integer = (-?{Digit}+)
Float   = (-?{Digit}+\.{Digit}+)
Symbol  = (({Alpha}|[_]|{Digit})+)
IdPart  = ({Upper}{Alpha}+)
Id      = ({IdPart}(\.{IdPart})*)
Remote  = (({Id}|{Symbol})\.{Symbol})
Kw      = (module|end|let|=|in|\[|\]|,|fn|->)
Ws      = [\s\n\r\t]

Rules.

{Integer} : {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{Float}   : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{Id}      : {token, {id, TokenLine, id(TokenChars)}}.
{Kw}      : {token, {list_to_atom(TokenChars), TokenLine}}.
{Symbol}  : {token, {symbol, TokenLine, list_to_atom(TokenChars)}}.
{Remote}  : {token, {remote, TokenLine, remote(TokenChars)}}.
\(\)      : {token, {unit, TokenLine}}.
"[^"]*"   : {token, {string, TokenLine, lists:sublist(TokenChars, 2, TokenLen - 2)}}.
{Ws}      : skip_token.

Erlang code.

id(Chars) ->
    list_to_atom("Riot." ++ Chars).

remote([C | _] = Chars) ->
    [Fun | ModuleParts] = lists:reverse(string:tokens(Chars, ".")),

    Module =
        case {C == string:to_lower(C), lists:reverse(ModuleParts)} of
            {true, [Part]} ->
                list_to_atom(Part);
            {false, Parts} ->
                id(string:join(Parts, "."))
        end,

    {Module, list_to_atom(Fun)}.
