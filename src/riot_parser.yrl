Nonterminals
  root.

Terminals
  integer.

Rootsymbol root.

root -> integer : convert_to_ast('$1').

Erlang code.
make_ast(Name, Value) -> {Name, Value, #{}}.
make_ast(Name, Value, L) -> {Name, Value, #{line => L}}.

convert_to_ast({Name, L}) -> make_ast(Name, [], L);
convert_to_ast({Name, L, Value}) -> make_ast(Name, [Value], L).
