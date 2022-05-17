module Club exposing
    ( Club
    , ClubId
    , clubDecoder
    , clubEncoder
    , clubsDecoder
    , emptyClub
    , idParser
    , idToString
    , newClubEncoder
    , scalarIdParser
    )

import API.Scmp.Scalar exposing (Id(..))
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)


type alias Club =
    { id : ClubId
    , name : String
    }


type ClubId
    = ClubId Int


clubsDecoder : Decoder (List Club)
clubsDecoder =
    list clubDecoder


clubDecoder : Decoder Club
clubDecoder =
    Decode.succeed Club
        |> required "id" idDecoder
        |> required "name" string


idDecoder : Decoder ClubId
idDecoder =
    Decode.map ClubId int


idToString : ClubId -> String
idToString (ClubId id) =
    String.fromInt id


idParser : Parser (ClubId -> a) a
idParser =
    custom "CLUBID" <|
        \clubId ->
            Maybe.map ClubId (String.toInt clubId)


scalarIdParser : Parser (Id -> a) a
scalarIdParser =
    custom "CLUBID" <|
        \clubId ->
            Just (Id clubId)


clubEncoder : Club -> Encode.Value
clubEncoder club =
    Encode.object
        [ ( "id", encodeId club.id )
        , ( "name", Encode.string club.name )
        ]


newClubEncoder : Club -> Encode.Value
newClubEncoder club =
    Encode.object
        [ ( "name", Encode.string club.name ) ]


encodeId : ClubId -> Encode.Value
encodeId (ClubId id) =
    Encode.int id


emptyClub : Club
emptyClub =
    { id = emptyClubId
    , name = ""
    }


emptyClubId : ClubId
emptyClubId =
    ClubId -1
