module API.CustomCodecs exposing (..)

import API.Scmp.Scalar as Scmp
import Date as Date
import Decimal
import Json.Decode as JsonDecode
import Json.Encode as JsonEncode
import Uuid


type alias Id =
    Scmp.Id


type alias NaiveDateTime =
    Date.Date


type alias Uuid =
    Uuid.Uuid


type alias Decimal =
    Decimal.Decimal


codecs : Scmp.Codecs Id NaiveDateTime
codecs =
    Scmp.defineCodecs
        { --codecDecimal = { encoder = decimalEncoder, decoder = decimalDecoder }
          codecId = Scmp.defaultCodecs.codecId
        , codecNaiveDateTime = { encoder = dateEncoder, decoder = dateDecoder }

        --, codecUuid = { encoder = uuidEncoder, decoder = uuidDecoder }
        }


decimalEncoder : Decimal -> JsonEncode.Value
decimalEncoder =
    Decimal.toString >> JsonEncode.string


decimalDecoder : JsonDecode.Decoder Decimal
decimalDecoder =
    JsonDecode.string
        |> JsonDecode.map Decimal.fromString
        |> JsonDecode.andThen
            (Maybe.map JsonDecode.succeed >> Maybe.withDefault (JsonDecode.fail "Could not decode graphQL scalar Decimal to Decimal."))


dateEncoder : NaiveDateTime -> JsonEncode.Value
dateEncoder =
    Date.toIsoString >> JsonEncode.string


dateDecoder : JsonDecode.Decoder NaiveDateTime
dateDecoder =
    JsonDecode.string
        |> JsonDecode.andThen
            (\isoString ->
                case Date.fromIsoString isoString of
                    Result.Ok date ->
                        JsonDecode.succeed date

                    Result.Err error ->
                        JsonDecode.fail ("Could not parse naive date as Date: " ++ error)
            )


uuidEncoder : Uuid -> JsonEncode.Value
uuidEncoder =
    Uuid.toString >> JsonEncode.string


uuidDecoder : JsonDecode.Decoder Uuid
uuidDecoder =
    JsonDecode.string
        |> JsonDecode.map Uuid.fromString
        |> JsonDecode.andThen
            (\maybeParsedId ->
                case maybeParsedId of
                    Just parsedId ->
                        JsonDecode.succeed parsedId

                    Nothing ->
                        JsonDecode.fail "Could not parse ID as an Uuid."
            )
