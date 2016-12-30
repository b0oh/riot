# Riot

— fighting against reasoning entropy

Based on Standard ML, revised

## Statements

* Everything should be questioned
* Everything should have a reason
* Code will be readen more often than writen
* Complexity should appear only when necessary
* Using already existing tools for fast start: mix, yacc, beam
* ...

## Zen

* No special cases
* Explicit better than implicit
* Designed better than ad-hoced
* Less surpise
* ...

## Syntax

Context free as on first step we are using lexx and yacc

* type by `:` vs `::` (#15)

  `:` — because see no reason why it should be anyhow different from "math" notation

* module system and importing (#16)

* exports

* let rec

* val and fun vs `apply x y = x y`

* let x = 1 in x vs x = 1

* nececity of unit

* application by space vs parens

  example of clarity
  ```
  template name = [
    h1 [] [text "Greetings"],
    div [] [text name]
  ]
  ```

* define types of function separately from function

* 2d layout vs

* `where`

  ```
  begin
    load_table
    print olo
  where
    olo = 1
  end
  ```

* `match`

  ```
  match expr with
    Ok value ->
      one ()
      |> two
    Error (ExprError code) ->
      "less then ten"
    Error _ ->
      "more then 9"
  end

  match expr with Ok value -> one (> two; three (); Error reason -> "olo" end
  ```

* `fn`
  ```
  fn
    x when x > 5 ->
      "piu"
    _ ->
      "olo"
  end

  fn x when x > 5 -> "piu"; _ -> "olo" end
  ```

* multiclause functions vs func x = match x with

* guards with comma or when

## Types
