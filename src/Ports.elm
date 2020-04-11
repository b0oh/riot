port module Ports exposing (stdin, stdout)

import Json.Encode as Json


port stdin : (Json.Value -> msg) -> Sub msg


port stdout : Json.Value -> Cmd msg
