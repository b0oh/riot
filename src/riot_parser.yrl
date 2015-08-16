Nonterminals
  root toplevels toplevel
  binding binding_args binding_arg
  app app_args
  expr fun list seq.

Terminals
  %% Keywords
  module end let fn

  %% Literal tokens
  integer float string symbol

  %% Separators
  '=' '[' ']' ',' '->'

  id remote unit.

Rootsymbol root.

root -> module id toplevels end : make_ast(module, [convert_to_ast('$2'), '$3'], ?line('$1')).

toplevels -> toplevel : ['$1'].
toplevels -> toplevel toplevels : ['$1' | '$2'].

toplevel -> binding : '$1'.

binding -> let symbol binding_args '=' expr : make_ast(binding, [convert_to_ast('$2'), '$3', '$5'], ?line('$1')).

binding_args -> binding_arg : ['$1'].
binding_args -> binding_arg binding_args : ['$1' | '$2'].

binding_arg -> symbol : convert_to_ast('$1').
binding_arg -> unit : convert_to_ast('$1').

expr -> integer : convert_to_ast('$1').
expr -> float : convert_to_ast('$1').
expr -> string : convert_to_ast('$1').
expr -> symbol : convert_to_ast('$1').
expr -> unit : convert_to_ast('$1').
expr -> list : '$1'.
expr -> fun : '$1'.
expr -> app : '$1'.

list -> '[' ']' : make_ast(list, [[]], ?line('$1')).
list -> '[' seq ']' : make_ast(list, ['$2'], ?line('$1')).

seq -> expr : ['$1'].
seq -> expr ',' seq : ['$1' | '$3'].

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
