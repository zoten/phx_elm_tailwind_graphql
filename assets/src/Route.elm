module Route exposing (Route(..), parseUrl, pushUrl)

--import Club exposing (ClubId)

import API.Scmp.Scalar exposing (Id(..))
import Browser.Navigation as Nav
import Club exposing (scalarIdParser)
import Post exposing (PostId)
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Posts
    | Post PostId
    | NewPost
    | Clubs
    | Club Id
    | NewClub


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Clubs top
        , map Posts (s "posts")
        , map Post (s "posts" </> Post.idParser)
        , map NewPost (s "posts" </> s "new")
        , map Clubs (s "clubs")
        , map NewClub (s "clubs" </> s "new")
        , map Club (s "clubs" </> scalarIdParser)
        ]


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Posts ->
            "/posts"

        Post postId ->
            "/posts/" ++ Post.idToString postId

        NewPost ->
            "/posts/new"

        Clubs ->
            "/clubs"

        Club clubId ->
            let
                clubIdStr =
                    case clubId of
                        Id value ->
                            value
            in
            "/clubs/" ++ clubIdStr

        NewClub ->
            "/clubs/new"
