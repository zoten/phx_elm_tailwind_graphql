module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.EditClub as EditClub
import Page.EditPost as EditPost
import Page.ListClubs as ListClubs
import Page.ListPosts as ListPosts
import Page.NewPost as NewPost
import Route exposing (Route)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | ListPage ListPosts.Model
    | EditPage EditPost.Model
    | NewPage NewPost.Model
    | ListClubsPage ListClubs.Model
    | EditClubPage EditClub.Model



-- | EditPage EditPost.Model
-- | NewPage NewPost.Model


type Msg
    = ListPageMsg ListPosts.Msg
    | ListClubsPageMsg ListClubs.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | EditPageMsg EditPost.Msg
    | NewPageMsg NewPost.Msg
    | EditClubPageMsg EditClub.Msg


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Posts ->
                    let
                        ( pageModel, pageCmds ) =
                            ListPosts.init
                    in
                    ( ListPage pageModel, Cmd.map ListPageMsg pageCmds )

                Route.Post postId ->
                    let
                        ( pageModel, pageCmd ) =
                            EditPost.init postId model.navKey
                    in
                    ( EditPage pageModel, Cmd.map EditPageMsg pageCmd )

                Route.NewPost ->
                    let
                        ( pageModel, pageCmd ) =
                            NewPost.init model.navKey
                    in
                    ( NewPage pageModel, Cmd.map NewPageMsg pageCmd )

                Route.Clubs ->
                    let
                        ( clubModel, pageCmds ) =
                            ListClubs.init
                    in
                    ( ListClubsPage clubModel, Cmd.map ListClubsPageMsg pageCmds )

                Route.Club clubId ->
                    let
                        ( pageModel, clubCmd ) =
                            EditClub.init clubId model.navKey
                    in
                    ( EditClubPage pageModel, Cmd.map EditClubPageMsg clubCmd )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )


view : Model -> Document Msg
view model =
    { title = "Scmp App"
    , body = [ templateView (currentView model) ]
    }


templateView : Html Msg -> Html Msg
templateView content =
    div []
        [ div [ class "container mx-auto" ]
            [ div [ class "flex flex-row flex-wrap py-4" ]
                [ aside [ class "w-full sm:w-1/3 md:w-1/4 px-2 bg-gradient-to-b from-slate-400 to-slate-100" ]
                    [ ul [ class "flex sm:flex-col overflow-hidden content-center justify-between list-none hover:list-disc" ]
                        [ li [] [ a [ href "/" ] [ text "Home" ] ]
                        , li [] [ text "hey" ]
                        , li [] [ text "man" ]
                        , li [] [ text "this is" ]
                        , li [] [ text "a sidebar" ]
                        ]
                    ]
                , main_ [ class "w-full sm:w-2/3 md:w-3/4 pt-1 px-2" ]
                    [ content
                    ]
                ]
            ]
        , div [ class "mt-auto" ]
            [ div [ class "container mx-auto bg-gradient-to-r from-slate-100 to-slate-400" ]
                [ text "footer" ]
            ]
        ]


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        ListPage pageModel ->
            ListPosts.view pageModel
                |> Html.map ListPageMsg

        EditPage pageModel ->
            EditPost.view pageModel
                |> Html.map EditPageMsg

        NewPage pageModel ->
            NewPost.view pageModel
                |> Html.map NewPageMsg

        ListClubsPage pageModel ->
            ListClubs.view pageModel
                |> Html.map ListClubsPageMsg

        EditClubPage pageModel ->
            EditClub.view pageModel
                |> Html.map EditClubPageMsg


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ListPageMsg subMsg, ListPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListPosts.update subMsg pageModel
            in
            ( { model | page = ListPage updatedPageModel }
            , Cmd.map ListPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( EditPageMsg subMsg, EditPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    EditPost.update subMsg pageModel
            in
            ( { model | page = EditPage updatedPageModel }
            , Cmd.map EditPageMsg updatedCmd
            )

        ( NewPageMsg subMsg, NewPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    NewPost.update subMsg pageModel
            in
            ( { model | page = NewPage updatedPageModel }
            , Cmd.map NewPageMsg updatedCmd
            )

        ( ListClubsPageMsg subMsg, ListClubsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListClubs.update subMsg pageModel
            in
            ( { model | page = ListClubsPage updatedPageModel }
            , Cmd.map ListClubsPageMsg updatedCmd
            )

        ( EditClubPageMsg subMsg, EditClubPage clubPageModel ) ->
            let
                ( updatedClubPageModel, updatedCmd ) =
                    EditClub.update subMsg clubPageModel
            in
            ( { model | page = EditClubPage updatedClubPageModel }
            , Cmd.map EditClubPageMsg updatedCmd
            )

        ( _, _ ) ->
            ( model, Cmd.none )
