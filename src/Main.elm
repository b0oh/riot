module Main exposing (main)

import Json.Decode as Decode
import Json.Encode as Json
import ML.Parser as Parser
import Platform
import Ports


type Message
    = Input String


prepareStdin : Decode.Value -> String
prepareStdin value =
    Decode.decodeValue Decode.string value
        |> Result.withDefault "error"


subscriptions model =
    Ports.stdin (prepareStdin >> Input)


update message model =
    case message of
        Input input ->
            let
                ast =
                    Parser.parse input

                _ =
                    Debug.log "qwe" ast
            in
            ( model, Json.string input |> Ports.stdout )


main : Program () () Message
main =
    Platform.worker
        { init = always ( (), Cmd.none )
        , subscriptions = subscriptions
        , update = update
        }
