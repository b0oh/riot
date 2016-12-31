Definitions.

Digit   = [0-9]
Integer = (-?{Digit}+)

Rules.

{Integer} : {token, {integer, TokenLine, list_to_integer(TokenChars)}}.

Erlang code.
