Nonterminals
  grammar expr expr_list eoe
  literal operator assignment application.

Terminals
  integer float var add_op mul_op comp_op ';' '=' '(' ')' eol.

Rootsymbol grammar.

Left 10 '='.
Left 20 comp_op.
Left 30 add_op.
Left 40 mul_op.

grammar -> '$empty' : unit().
grammar -> eoe : unit('$1').
grammar -> expr_list : make_seq('$1').
grammar -> eoe expr_list : make_seq('$2').
grammar -> expr_list eoe : make_seq('$1').

eoe -> eol : '$1'.
eoe -> ';' : '$1'.

expr_list -> expr : ['$1'].
expr_list -> expr eoe expr_list : ['$1' | '$3'].

expr -> '(' expr ')' : '$2'.
expr -> literal : '$1'.
expr -> var : convert_to_ast('$1').
expr -> assignment : '$1'.
expr -> application : '$1'.

literal -> integer : convert_to_ast('$1').
literal -> float : convert_to_ast('$1').

assignment -> var '=' expr :
  make_ast(assignment, [convert_to_ast('$1'), '$3']).

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

make_seq(Exprs) -> make_ast(seq, [Exprs]).

extract_operator({_, L, Value}) -> make_ast(var, [Value], L).

unit() ->
  make_ast(unit, []).

unit(Token) ->
  {_, _, #{line := Line}} = convert_to_ast(Token),
  make_ast(unit, [], Line).
