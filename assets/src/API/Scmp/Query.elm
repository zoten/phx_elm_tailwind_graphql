-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module API.Scmp.Query exposing (..)

import API.CustomCodecs
import API.Scmp.InputObject
import API.Scmp.Interface
import API.Scmp.Object
import API.Scmp.Scalar
import API.Scmp.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


{-| Get a list of all clubs
-}
clubs :
    SelectionSet decodesTo API.Scmp.Object.Club
    -> SelectionSet (Maybe (List (Maybe decodesTo))) RootQuery
clubs object____ =
    Object.selectionForCompositeField "clubs" [] object____ (Basics.identity >> Decode.nullable >> Decode.list >> Decode.nullable)


type alias UserRequiredArguments =
    { id : API.CustomCodecs.Id }


{-| Get a user
-}
user :
    UserRequiredArguments
    -> SelectionSet decodesTo API.Scmp.Object.User
    -> SelectionSet (Maybe decodesTo) RootQuery
user requiredArgs____ object____ =
    Object.selectionForCompositeField "user" [ Argument.required "id" requiredArgs____.id (API.CustomCodecs.codecs |> API.Scmp.Scalar.unwrapEncoder .codecId) ] object____ (Basics.identity >> Decode.nullable)