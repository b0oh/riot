Nonterminals
  grammar expr
  literal operator application.

Terminals
  integer float add_op mul_op comp_op '(' ')'.

Rootsymbol grammar.

Left 10 comp_op.
Left 20 add_op.
Left 30 mul_op.

grammar -> expr : '$1'.

expr -> '(' expr ')' : '$2'.
expr -> literal : '$1'.
expr -> application : '$1'.

literal -> integer : convert_to_ast('$1').
literal -> float : convert_to_ast('$1').

application -> expr operator expr :
  make_ast(application, ['$2', ['$1', '$3']]).

operator -> add_op : extract_operator('$1').
operator -> mul_op : extract_operator('$1').
operator -> comp_op : extract_operator('$1').

Erlang code.
make_ast(Name, Value) -> {Name, Value, #{}}.
make_ast(Name, Value, L) -> {Name, Value, #{line => L}}.

convert_to_ast({Name, L}) -> make_ast(Name, [], L);
convert_to_ast({Name, L, Value}) -> make_ast(Name, [Value], L).

extract_operator({_, L, Value}) -> make_ast(Value, [], L).
