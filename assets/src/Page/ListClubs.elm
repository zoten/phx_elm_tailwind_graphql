module Page.ListClubs exposing (Model, Msg, init, update, view)

import API.CustomCodecs exposing (Id)
import API.Scmp.Object
import API.Scmp.Object.Club
import API.Scmp.Query as Query
import Club exposing (Club, ClubId, clubsDecoder)
import Error exposing (buildErrorMessage)
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (..)
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
    SelectionSet.map2 Club
        API.Scmp.Object.Club.id
        API.Scmp.Object.Club.name


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
    div []
        [ button [ onClick FetchClubs ]
            [ text "Refresh clubs" ]
        , br [] []
        , br [] []
        , a [ href "/clubs/new" ]
            [ text "Create new club" ]
        , viewClubs model.clubs
        , viewDeleteError model.deleteError
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
                , table []
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
        ]


fromJust : Maybe a -> a -> a
fromJust x default =
    case x of
        Just y ->
            y

        Nothing ->
            default


viewClub : Maybe Club -> Html Msg
viewClub maybeclub =
    let
        clubPath =
            --"/clubs/" ++ Club.idToString (fromJust club.id (Id 0))
            "/clubs/fixme"
    in
    case maybeclub of
        Just club ->
            tr []
                [ --  td []
                  -- [ text (Club.idToString (fromJust club.id 0)) ],
                  td []
                    [ text (fromJust club.name "--") ]
                , td []
                    [ a [ href clubPath ] [ text "Edit" ] ]

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
