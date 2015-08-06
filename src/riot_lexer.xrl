Definitions.

Digit  = [0-9]
Alpha  = [A-Za-z]
Symbol = ({Alpha}|[_\?])
Ws     = [\s\n\r\t]

Rules.

-?{Digit}+           : {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
-?{Digit}+\.{Digit}+ : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{Symbol}+            : {token, {symbol, TokenLine, list_to_atom(TokenChars)}}.
=                    : {token, {bind, TokenLine}}.
"[^"]*"              : {token, {string, TokenLine, lists:sublist(TokenChars, 2, TokenLen - 2)}}.
{Ws}                 : skip_token.

Erlang code.
