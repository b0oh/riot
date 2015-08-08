# Riot

hello.rt

```sml
module Hello
  let say () = io.format "What?~n"
  let hello name = io.format "Hello, ~s.~n" [name]
end
```

```sh
$ ./rebar3 do compile, shell
1> riot_compiler:file("hello.rt", "_build/default/lib/riot/ebin/Riot.Hello.beam").
{ok,'Riot.Hello',[]}
2> 'Riot.Hello':hello("Burning Bear Ex Machina").
Hello, Burning Bear Ex Machina.
ok
```
