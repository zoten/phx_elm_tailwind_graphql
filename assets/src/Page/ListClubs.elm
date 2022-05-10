module Page.ListClubs exposing (Model, Msg, init, update, view)

import Club exposing (Club, ClubId, clubsDecoder)
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import RemoteData exposing (WebData)


type alias Model =
    { clubs : WebData (List Club)
    , deleteError : Maybe String
    }


type Msg
    = FetchClubs
    | ClubsReceived (WebData (List Club))
    | DeleteClub ClubId
    | ClubDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchClubs )


initialModel : Model
initialModel =
    { clubs = RemoteData.Loading
    , deleteError = Nothing
    }


fetchClubs : Cmd Msg
fetchClubs =
    Http.get
        { url = "http://localhost:4000/clubs/"
        , expect =
            clubsDecoder
                |> Http.expectJson (RemoteData.fromResult >> ClubsReceived)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchClubs ->
            ( { model | clubs = RemoteData.Loading }, fetchClubs )

        ClubsReceived response ->
            ( { model | clubs = response }, Cmd.none )

        DeleteClub clubId ->
            ( model, deleteClub clubId )

        ClubDeleted (Ok _) ->
            ( model, fetchClubs )

        ClubDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )


deleteClub : ClubId -> Cmd Msg
deleteClub clubId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:4000/clubs/" ++ Club.idToString clubId
        , body = Http.emptyBody
        , expect = Http.expectString ClubDeleted
        , timeout = Nothing
        , tracker = Nothing
        }



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


viewClubs : WebData (List Club) -> Html Msg
viewClubs clubs =
    case clubs of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success actualClubs ->
            div []
                [ h3 [] [ text "Clubs" ]
                , table []
                    ([ viewTableHeader ] ++ List.map viewClub actualClubs)
                ]

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewClub : Club -> Html Msg
viewClub club =
    let
        clubPath =
            "/clubs/" ++ Club.idToString club.id
    in
    tr []
        [ td []
            [ text (Club.idToString club.id) ]
        , td []
            [ text club.name ]
        , td []
            [ a [ href clubPath ] [ text "Edit" ] ]
        , td []
            [ button [ type_ "button", onClick (DeleteClub club.id) ]
                [ text "Delete" ]
            ]
        ]


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
