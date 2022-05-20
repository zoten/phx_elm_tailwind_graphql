-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module API.Scmp.Object.User exposing (..)

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
import Json.Decode as Decode


clubs :
    SelectionSet decodesTo API.Scmp.Object.Club
    -> SelectionSet (Maybe (List (Maybe decodesTo))) API.Scmp.Object.User
clubs object____ =
    Object.selectionForCompositeField "clubs" [] object____ (Basics.identity >> Decode.nullable >> Decode.list >> Decode.nullable)


clubsCount : SelectionSet (Maybe Int) API.Scmp.Object.User
clubsCount =
    Object.selectionForField "(Maybe Int)" "clubsCount" [] (Decode.int |> Decode.nullable)


id : SelectionSet (Maybe API.CustomCodecs.Id) API.Scmp.Object.User
id =
    Object.selectionForField "(Maybe API.CustomCodecs.Id)" "id" [] (API.CustomCodecs.codecs |> API.Scmp.Scalar.unwrapCodecs |> .codecId |> .decoder |> Decode.nullable)


insertedAt : SelectionSet (Maybe API.CustomCodecs.NaiveDateTime) API.Scmp.Object.User
insertedAt =
    Object.selectionForField "(Maybe API.CustomCodecs.NaiveDateTime)" "insertedAt" [] (API.CustomCodecs.codecs |> API.Scmp.Scalar.unwrapCodecs |> .codecNaiveDateTime |> .decoder |> Decode.nullable)


name : SelectionSet (Maybe String) API.Scmp.Object.User
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)
