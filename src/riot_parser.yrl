Nonterminals
  root toplevels toplevel
  binding binding_args binding_arg
  app app_args
  expr list seq.

Terminals
   module end let '=' '[' ']' ',' integer float string id symbol remote unit.

Rootsymbol root.

root -> module id toplevels end : {module, '$2', '$3'}.

toplevels -> toplevel : ['$1'].
toplevels -> toplevel toplevels : ['$1' | '$2'].

toplevel -> binding : '$1'.

binding -> let symbol binding_args '=' expr : {binding, '$2', '$3', '$5'}.

binding_args -> binding_arg : ['$1'].
binding_args -> binding_arg binding_args : ['$1' | '$2'].

binding_arg -> symbol : '$1'.
binding_arg -> unit : '$1'.

expr -> integer : '$1'.
expr -> float : '$1'.
expr -> string : '$1'.
expr -> symbol : '$1'.
expr -> list : '$1'.
expr -> unit : '$1'.
expr -> app : '$1'.

list -> '[' ']' : {list, ?line('$1'), []}.
list -> '[' seq ']' : {list, ?line('$1'), '$2'}.

seq -> expr : ['$1'].
seq -> expr ',' seq : ['$1' | '$3'].

app -> symbol app_args : {app, '$1', '$2'}.
app -> remote app_args : {app, '$1', '$2'}.

app_args -> expr : ['$1'].
app_args -> expr app_args : ['$1' | '$2'].

Erlang code.

-define(line(Node), element(2, Node)).
