module Page.NewClub exposing (..)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Route


type alias Model =
    { navKey : Nav.Key
    , club : ClubFormData
    , createError : Maybe String
    }


type alias ClubFormData =
    { name : String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , club = emptyClubFormData
    , createError = Nothing
    }


emptyClubFormData : ClubFormData
emptyClubFormData =
    ClubFormData ""


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Create New Club" ]
        , newClubForm
        , viewError model.createError
        ]


newClubForm : Html Msg
newClubForm =
    Html.form []
        [ div [ class "relative z-0 w-full mb-6 group" ]
            [ label [ for "name" ] [ text "Name" ]
            , br [] []
            , input [ id "name", type_ "text", class "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", onInput StoreName ] []
            ]
        , div []
            [ button [ class "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800" ] [ text "Create" ]
            ]
        ]


type Msg
    = StoreName String
    | CreateClub
    | ClubCreated (Result Http.Error ClubFormData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoreName name ->
            let
                oldClub =
                    model.club

                updateName =
                    { oldClub | name = name }
            in
            ( { model | club = updateName }, Cmd.none )

        CreateClub ->
            --( model, createClub model.club )
            ( model, Cmd.none )

        ClubCreated (Ok club) ->
            ( { model | club = club, createError = Nothing }
            , Route.pushUrl Route.Clubs model.navKey
            )

        ClubCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )



-- createClub : Club -> Cmd Msg
-- createClub post =
--     Http.post
--         { url = "http://localhost:4000/posts"
--         , body = Http.jsonBody (newClubEncoder post)
--         , expect = Http.expectJson ClubCreated postDecoder
--         }


viewError : Maybe String -> Html msg
viewError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't create a club at this time." ]
                , text ("Error: " ++ error)
                ]

        Nothing ->
            text ""
