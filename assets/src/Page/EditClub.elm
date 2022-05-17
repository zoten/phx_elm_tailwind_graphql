module Page.EditClub exposing (Model, Msg, init, update, view)

--import Club exposing (Club, ClubId(..), clubDecoder, clubEncoder)

import API.Scmp.Object
import API.Scmp.Object.Club as Club
import API.Scmp.Query as Query
import API.Scmp.Scalar exposing (Id(..))
import Browser.Navigation as Nav
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import RemoteData exposing (RemoteData)


type alias Model =
    { navKey : Nav.Key
    , club : RemoteData (Graphql.Http.Error (Maybe ClubData)) (Maybe ClubData)
    , clubId : Id
    , saveError : Maybe String
    , deleteError : Maybe String
    }


type alias ClubData =
    { id : Maybe Id
    , name : Maybe String
    }



-- query : SelectionSet (Maybe ClubData) RootQuery
-- query =
--     Query.club { id = Id "2" } clubSelection


type Msg
    = FetchClub
    | ClubReceived (RemoteData (Graphql.Http.Error (Maybe ClubData)) (Maybe ClubData))



-- | AddUser String
-- | UserAdded (Result Http.Error Club)


init : Id -> Nav.Key -> ( Model, Cmd Msg )
init clubId navKey =
    ( initialModel clubId navKey, fetchClub clubId )



--( initialModel clubId navKey, Cmd.none )


initialModel : Id -> Nav.Key -> Model
initialModel clubId navKey =
    { navKey = navKey
    , club = RemoteData.Loading
    , clubId = clubId
    , saveError = Nothing
    , deleteError = Nothing
    }


fetchClubQuery : Query.ClubRequiredArguments -> SelectionSet (Maybe ClubData) RootQuery
fetchClubQuery id =
    Query.club id clubSelection



-- clubListSelection : SelectionSet Club API.Scmp.Object.Club
-- clubListSelection =
--     SelectionSet.map2 Club
--         API.Scmp.Object.Club.id
--         API.Scmp.Object.Club.name


clubSelection : SelectionSet ClubData API.Scmp.Object.Club
clubSelection =
    SelectionSet.map2 ClubData
        Club.id
        Club.name


makeGraphQLQuery : SelectionSet decodesTo RootQuery -> (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> Cmd msg
makeGraphQLQuery query decodesTo =
    query
        |> Graphql.Http.queryRequest "http://localhost:4000/api"
        |> Graphql.Http.send decodesTo


fetchClub : Id -> Cmd Msg
fetchClub id =
    makeGraphQLQuery (fetchClubQuery { id = id })
        (RemoteData.fromResult >> ClubReceived)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchClub ->
            -- ( { model | club = RemoteData.Loading }, fetchClub )
            ( { model | club = RemoteData.Loading }, Cmd.none )

        ClubReceived response ->
            ( { model | club = response }, Cmd.none )


getClubId : Id -> String
getClubId clubId =
    case clubId of
        Id id ->
            id


view : Model -> Html Msg
view model =
    div [ class "grid m-4 gap-4" ]
        [ text ("id is " ++ getClubId model.clubId)
        , viewClub model.club
        ]


viewClub : RemoteData (Graphql.Http.Error (Maybe ClubData)) (Maybe ClubData) -> Html Msg
viewClub clubResponse =
    case clubResponse of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualClub ->
            let
                content =
                    case actualClub of
                        Just club ->
                            [ viewClubHeader club, viewClubData club ]

                        Nothing ->
                            [ p [] [ text "Nothing to show :(" ] ]
            in
            div []
                [ h3 [] [ text "Club " ]
                , div [] content
                ]

        RemoteData.Failure _ ->
            viewFetchError "HTTP Error"


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


viewClubHeader : ClubData -> Html Msg
viewClubHeader club =
    let
        name =
            case club.name of
                Just value ->
                    value

                Nothing ->
                    "(noname)"
    in
    h1 [] [ text ("Club Header: " ++ name) ]


viewClubData : ClubData -> Html Msg
viewClubData _ =
    h1 [] [ text "club" ]



-- viewClub : RemoteData (Graphql.Http.Error Club) Club -> Html Msg
-- viewClub clubsResponse =
--     case clubsResponse of
--         RemoteData.NotAsked ->
--             text ""
--         RemoteData.Loading ->
--             h3 [] [ text "Loading..." ]
--         RemoteData.Success actualClub ->
--             let
--                 content =
--                     case actualClub of
--                         Just club ->
--                             viewTableHeader :: List.map viewClub club
--                         Nothing ->
--                             [ p [] [ text "Nothing to show" ] ]
--             in
--             div []
--                 [ h3 [] [ text "Clubs" ]
--                 , table [ class "table-fixed text-left min-w-full divide-y divide-gray-200 dark:divide-gray-700" ]
--                     content
--                 ]
--         --RemoteData.Failure httpError ->
--         --viewFetchError (buildErrorMessage httpError)
--         RemoteData.Failure _ ->
--             viewFetchError "HTTP Error"
-- viewTableHeader : Html Msg
-- viewTableHeader =
--     tr []
--         [ th []
--             [ text "ID" ]
--         , th []
--             [ text "Name" ]
--         , th []
--             [ text "Users" ]
--         ]
-- viewFetchError : String -> Html Msg
-- viewFetchError errorMessage =
--     let
--         errorHeading =
--             "Couldn't fetch club at this time."
--     in
--     div []
--         [ h3 [] [ text errorHeading ]
--         , text ("Error: " ++ errorMessage)
--         ]
-- viewDeleteError : Maybe String -> Html msg
-- viewDeleteError maybeError =
--     case maybeError of
--         Just error ->
--             div []
--                 [ h3 [] [ text "Couldn't delete club at this time." ]
--                 , text ("Error: " ++ error)
--                 ]
--         Nothing ->
--             text ""
