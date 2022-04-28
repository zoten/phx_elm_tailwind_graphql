module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { x : Int }


init : Model
init =
    { x = 0 }


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | x = model.x + 1 }

        Decrement ->
            { model | x = model.x - 1 }
        
        Reset ->
            { model | x = 0 }


view : Model -> Html.Html Msg
view model =
    div [ class "grid m-4" ]
        [ h1 [ class "flex justify-center font-bold text-4xl text-yellow-500" ] [ text "Elm and Tailwind CSS" ]
        , div [ class "flex justify-center" ] [ viewCounter model ]
        , div [ class "flex justify-center" ] [ a [ href "https://github.com/zoten/phx_elm_tailwind_graphql" ] [ text "https://github.com/zoten/phx_elm_tailwind_graphql" ] ]
        ]

viewCounter : Model -> Html.Html Msg
viewCounter model =
    div
        [ class "flex p-4" ]
        [ button [ class "btn m-4", onClick Decrement ] [ text "-" ]
        , div [ class "m-4 font-bold text-xl text-gray-600" ] [ text (String.fromInt model.x) ]
        , button [ class "btn m-4", onClick Increment ] [ text "+" ]
        , button [ class "btn m-4", onClick Reset ] [ text "R" ]
        ]

