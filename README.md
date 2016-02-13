# Riot

hello.rt

```sml
module Hello
  let say () = io.format "What?~n"
  let hello name = io.format "Hello, ~s.~n" [name]
  let lambda () = fn x y -> [x, y]
  let let list = let [_x, y] = list in y
  let lambda2 x =
    let q = 1
        f a = [a, x, q]
    in f
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
