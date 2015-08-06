Nonterminals toplevels toplevel expr.
Terminals integer float symbol string bind.

Rootsymbol toplevels.

toplevels -> toplevel : ['$1'].
toplevels -> toplevel toplevels : ['$1' | '$2'].

toplevel -> symbol bind expr : {toplevel, '$1', '$3'}.

expr -> integer : '$1'.
expr -> float : '$1'.
expr -> string : '$1'.

Erlang code.
