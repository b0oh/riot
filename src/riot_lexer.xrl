Definitions.

Digit     = [0-9]
Integer   = (-?{Digit}+)
Float     = (-?{Digit}+\.{Digit}+)
Add       = (\+|-)
Mul       = (\*|//|/|%)
Comp      = (<|<=|==|/=|>=|>)
Keyword   = (\(|\))
White     = [\s\n\r\t]

Rules.

{Integer} : make_token(integer, TokenChars, TokenLine).
{Float}   : make_token(float, TokenChars, TokenLine).
{Keyword} : make_token(keyword, TokenChars, TokenLine).
{Add}     : make_token(add_op, TokenChars, TokenLine).
{Mul}     : make_token(mul_op, TokenChars, TokenLine).
{Comp}    : make_token(comp_op, TokenChars, TokenLine).
{White}   : skip_token.

Erlang code.
make_token(Token0, TokenChars, TokenLine) ->
  Token1 =
    case Token0 of
      integer ->
        {integer, TokenLine, list_to_integer(TokenChars)};
      float ->
        {float, TokenLine, list_to_float(TokenChars)};
      keyword ->
        {list_to_atom(TokenChars), TokenLine};
      Op when Op == add_op orelse Op == mul_op orelse Op == comp_op ->
        {Op, TokenLine, list_to_atom(TokenChars)}
    end,
  {token, Token1}.
