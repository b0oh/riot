module ML.Parser exposing (parse)

import ML.Ast as Ast exposing (Ast)
import Parser exposing ((|.), (|=), Parser)


ast : Parser Ast
ast =
    Parser.int
        |> Parser.map Ast.Int


loopAst : Parser (List Ast)
loopAst =
    let
        step : List Ast -> Parser (Parser.Step (List Ast) (List Ast))
        step reversedAcc =
            let
                loop innerAst =
                    Parser.Loop (innerAst :: reversedAcc)

                done =
                    Parser.Done (List.reverse reversedAcc)
            in
            Parser.oneOf
                [ Parser.succeed loop
                    |= ast
                    |. Parser.spaces
                , Parser.succeed done
                ]
    in
    Parser.loop [] step


parse : String -> Result String (List Ast)
parse input =
    Parser.run loopAst input
        |> Result.mapError (always "error")
