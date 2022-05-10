module Club exposing (Club, clubDecoder, clubsDecoder)

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)


type alias Club =
    { id : Int
    , name : String
    }


clubsDecoder : Decoder (List Club)
clubsDecoder =
    list clubDecoder


clubDecoder : Decoder Post
clubDecoder =
    Decode.succeed Post
        |> required "id" int
        |> required "name" string
