Nonterminals
  root toplevels toplevel
  toplevel_binding binding_args binding_arg
  let_statement let_bindings let_binding
  app app_args
  expr literal nested_literal
  list tuple seq literal_list literal_tuple literal_seq
  fun.

Terminals
  module end let '=' in '[' ']' '(' ')' ',' fn '->' integer float string id symbol remote unit.

Rootsymbol root.

root -> module id toplevels end : make_ast(module, [convert_to_ast('$2'), '$3'], ?line('$1')).

toplevels -> toplevel : ['$1'].
toplevels -> toplevel toplevels : ['$1' | '$2'].

toplevel -> toplevel_binding : '$1'.

toplevel_binding -> let symbol binding_args '=' expr : make_ast(binding, [convert_to_ast('$2'), '$3', '$5'], ?line('$1')).

binding_args -> binding_arg : ['$1'].
binding_args -> binding_arg binding_args : ['$1' | '$2'].

binding_arg -> symbol : convert_to_ast('$1').
binding_arg -> unit : convert_to_ast('$1').

expr -> literal : '$1'.
expr -> list : '$1'.
expr -> tuple : '$1'.
expr -> let_statement : '$1'.
expr -> fun : '$1'.
expr -> app : '$1'.

literal -> integer : convert_to_ast('$1').
literal -> float : convert_to_ast('$1').
literal -> string : convert_to_ast('$1').
literal -> symbol : convert_to_ast('$1').
literal -> unit : convert_to_ast('$1').

list -> '[' ']' : make_ast(list, [[]], ?line('$1')).
list -> '[' seq ']' : make_ast(list, ['$2'], ?line('$1')).

tuple -> '(' seq ')' : make_ast(tuple, ['$2'], ?line('$1')).

seq -> expr : ['$1'].
seq -> expr ',' seq : ['$1' | '$3'].

let_statement -> let let_bindings in expr : make_ast('let', ['$2', '$4'], ?line('$1')).

let_bindings -> let_binding : ['$1'].
let_bindings -> let_binding let_bindings : ['$1' | '$2'].

let_binding -> nested_literal '=' expr : {'$1', '$3'}.
let_binding -> symbol binding_args '=' expr : {convert_to_ast('$1'),
                                               make_ast('fn', ['$2', '$4'], ?line('$1'))}.

nested_literal -> literal : '$1'.
nested_literal -> literal_list : '$1'.
nested_literal -> literal_tuple : '$1'.

literal_list -> '[' ']' : make_ast(list, [[]], ?line('$1')).
literal_list -> '[' literal_seq ']' : make_ast(list, ['$2'], ?line('$1')).

literal_tuple -> '(' literal_seq ')' : make_ast(tuple, ['$2'], ?line('$1')).

literal_seq -> nested_literal : ['$1'].
literal_seq -> nested_literal ',' literal_seq : ['$1' | '$3'].

fun -> fn binding_args '->' expr : make_ast('fn', ['$2', '$4'], ?line('$1')).

app -> symbol app_args : make_ast(app, [convert_to_ast('$1'), '$2']).
app -> remote app_args : make_ast(app, [convert_to_ast('$1'), '$2']).

app_args -> expr : ['$1'].
app_args -> expr app_args : ['$1' | '$2'].

Erlang code.
-define(line(Node), element(2, Node)).

make_ast(Name, Value) -> {Name, Value, #{}}.
make_ast(Name, Value, L) -> {Name, Value, #{line => L}}.

convert_to_ast({Name, L}) -> make_ast(Name, [], L);
convert_to_ast({Name, L, Value}) -> make_ast(Name, [Value], L).
