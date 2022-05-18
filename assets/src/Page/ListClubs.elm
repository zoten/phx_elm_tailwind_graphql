module Page.ListClubs exposing (Model, Msg, init, update, view)

--import API.CustomCodecs exposing (Id)

import API.Scmp.Object
import API.Scmp.Object.Club
import API.Scmp.Query as Query
import API.Scmp.Scalar exposing (Id(..))
import Club exposing (Club, ClubId, clubsDecoder)
import Error exposing (buildErrorMessage)
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html, a, br, button, div, h1, h3, p, table, td, text, th, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData, WebData)


type alias Model =
    { clubs : RemoteData (Graphql.Http.Error Clubs) Clubs
    , deleteError : Maybe String
    }


type alias Club =
    { id : Maybe Id
    , name : Maybe String
    , usersCount : Maybe Int
    }


type alias Clubs =
    Maybe (List (Maybe Club))


type Msg
    = FetchClubs
    | ClubsReceived (RemoteData (Graphql.Http.Error Clubs) Clubs)



-- | DeleteClub ClubId
-- | ClubDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchClubs )


initialModel : Model
initialModel =
    { clubs = RemoteData.Loading
    , deleteError = Nothing
    }


fetchClubsQuery : SelectionSet Clubs RootQuery
fetchClubsQuery =
    Query.clubs clubListSelection


clubListSelection : SelectionSet Club API.Scmp.Object.Club
clubListSelection =
    SelectionSet.map3 Club
        API.Scmp.Object.Club.id
        API.Scmp.Object.Club.name
        API.Scmp.Object.Club.usersCount


makeGraphQLQuery : SelectionSet decodesTo RootQuery -> (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> Cmd msg
makeGraphQLQuery query decodesTo =
    query
        |> Graphql.Http.queryRequest "http://localhost:4000/api"
        |> Graphql.Http.send decodesTo


fetchClubs : Cmd Msg
fetchClubs =
    makeGraphQLQuery fetchClubsQuery
        (RemoteData.fromResult >> ClubsReceived)



-- (RemoteData.fromResult
--     >> ClubsReceived
-- )
-- (Graphql.Http.parseableErrorAsSuccess
--     >> Graphql.Http.withSimpleHttpError
-- (RemoteData.fromResult
--     >> ClubsReceived
-- )
-- Http.get
--     { url = "http://localhost:4000/clubs/"
--     , expect =
--         clubsDecoder
--             |> Http.expectJson (RemoteData.fromResult >> ClubsReceived)
--     }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchClubs ->
            ( { model | clubs = RemoteData.Loading }, fetchClubs )

        ClubsReceived response ->
            ( { model | clubs = response }, Cmd.none )



-- DeleteClub clubId ->
--     ( model, deleteClub clubId )
-- ClubDeleted (Ok _) ->
--     ( model, fetchClubs )
-- ClubDeleted (Err error) ->
--     ( { model | deleteError = Just (buildErrorMessage error) }
--     , Cmd.none
--     )
-- deleteClub : ClubId -> Cmd Msg
-- deleteClub clubId =
--     Http.request
--         { method = "DELETE"
--         , headers = []
--         , url = "http://localhost:4000/clubs/" ++ Club.idToString clubId
--         , body = Http.emptyBody
--         , expect = Http.expectString ClubDeleted
--         , timeout = Nothing
--         , tracker = Nothing
--         }
-- VIEWS


view : Model -> Html Msg
view model =
    div [ class "grid m-4 gap-4" ]
        [ div [ class "col-auto" ]
            [ div [ class "row-auto" ]
                [ h1 [ class "flex justify-center font-bold text-4xl text-yellow-500" ]
                    [ text "Scmp + Tailwind" ]
                ]
            ]
        , br [] []
        , br [] []
        , div [ class "col-auto" ]
            [ div [ class "row-auto" ]
                [ a [ href "/clubs/new" ]
                    [ text "Create new club" ]
                ]
            ]
        , viewClubs model.clubs
        , viewDeleteError model.deleteError
        , button
            [ class "px-4 py-2 font-semibold text-sm bg-cyan-500 text-white rounded-full shadow-sm"
            , onClick FetchClubs
            ]
            [ text "Refresh clubs" ]
        ]


viewClubs : RemoteData (Graphql.Http.Error Clubs) Clubs -> Html Msg
viewClubs clubsResponse =
    case clubsResponse of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualClubs ->
            let
                content =
                    case actualClubs of
                        Just clubs ->
                            viewTableHeader :: List.map viewClub clubs

                        Nothing ->
                            [ p [] [ text "Nothing to show" ] ]
            in
            div []
                [ h3 [] [ text "Clubs" ]
                , table [ class "table-auto text-left min-w-full divide-y divide-gray-200 dark:divide-gray-700" ]
                    content
                ]

        --RemoteData.Failure httpError ->
        --viewFetchError (buildErrorMessage httpError)
        RemoteData.Failure _ ->
            viewFetchError "HTTP Error"


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Name" ]
        , th []
            [ text "Users" ]
        ]


getClubId : Maybe Id -> String
getClubId clubId =
    case clubId of
        Just (Id id) ->
            id

        Nothing ->
            "--"


viewClub : Maybe Club -> Html Msg
viewClub maybeclub =
    case maybeclub of
        Just club ->
            let
                clubPath =
                    --"/clubs/" ++ Club.idToString (fromJust club.id (Id 0))
                    "/clubs/" ++ getClubId club.id
            in
            tr []
                [ td []
                    [ text (getClubId club.id) ]
                , td []
                    [ text (Maybe.withDefault "--" club.name) ]
                , td []
                    [ text (String.fromInt (Maybe.withDefault 0 club.usersCount)) ]
                , td []
                    [ a [ href clubPath ]
                        [ button [ class "px-4 py-2 font-semibold text-sm bg-cyan-500 text-white rounded-full shadow-sm" ]
                            [ text "Edit" ]
                        ]
                    ]

                -- , td []
                --     [ button [ type_ "button", onClick (DeleteClub club.id) ]
                --         [ text "Delete" ]
                --     ]
                ]

        Nothing ->
            p [] [ text "No club to show" ]


viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch clubs at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewDeleteError : Maybe String -> Html msg
viewDeleteError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't delete club at this time." ]
                , text ("Error: " ++ error)
                ]

        Nothing ->
            text ""
