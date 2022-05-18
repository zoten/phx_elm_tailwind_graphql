module Page.EditClub exposing (Model, Msg, init, update, view)

--import Club exposing (Club, ClubId(..), clubDecoder, clubEncoder)

import API.Scmp.Mutation as Mutation
import API.Scmp.Object
import API.Scmp.Object.Club as Club
import API.Scmp.Object.DeleteUserFromClubResponse
import API.Scmp.Object.User as User exposing (..)
import API.Scmp.Query as Query
import API.Scmp.Scalar exposing (Id(..))
import Browser.Navigation as Nav
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
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


type alias UserData =
    { id : Maybe Id
    , name : Maybe String
    }


type alias ClubData =
    { id : Maybe Id
    , name : Maybe String
    , users : Maybe (List (Maybe UserData))
    }


type alias DeleteUserData =
    { outcome : Maybe Bool
    }


type alias DeleteUserResponse =
    Maybe DeleteUserData



-- query : SelectionSet (Maybe ClubData) RootQuery
-- query =
--     Query.club { id = Id "2" } clubSelection


type Msg
    = FetchClub Id
    | ClubReceived (RemoteData (Graphql.Http.Error (Maybe ClubData)) (Maybe ClubData))
    | DeleteUser Id
    | UserDeleted (RemoteData (Graphql.Http.Error (Maybe DeleteUserData)) (Maybe DeleteUserData))



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
    SelectionSet.map3 ClubData
        Club.id
        Club.name
        (Club.users (SelectionSet.map2 UserData User.id User.name))


makeGraphQLQuery : SelectionSet decodesTo RootQuery -> (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> Cmd msg
makeGraphQLQuery query decodesTo =
    query
        |> Graphql.Http.queryRequest "http://localhost:4000/api"
        |> Graphql.Http.send decodesTo


fetchClub : Id -> Cmd Msg
fetchClub id =
    makeGraphQLQuery (fetchClubQuery { id = id })
        (RemoteData.fromResult >> ClubReceived)



-- Delete user from club


deleteUserSelection : SelectionSet DeleteUserData API.Scmp.Object.DeleteUserFromClubResponse
deleteUserSelection =
    SelectionSet.map DeleteUserData
        API.Scmp.Object.DeleteUserFromClubResponse.outcome


sendDeleteUserMutation : Id -> Id -> SelectionSet DeleteUserResponse RootMutation
sendDeleteUserMutation club_id user_id =
    Mutation.deleteUserFromClub
        { clubId = club_id, userId = user_id }
        deleteUserSelection


deleteUserFromClub : Id -> Id -> Cmd Msg
deleteUserFromClub clubId userId =
    sendDeleteUserMutation clubId userId
        |> Graphql.Http.mutationRequest "http://localhost:4000/api"
        |> Graphql.Http.send (RemoteData.fromResult >> UserDeleted)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchClub id ->
            ( { model | club = RemoteData.Loading }, fetchClub id )

        -- ( { model | club = RemoteData.Loading }, Cmd.none )
        ClubReceived response ->
            ( { model | club = response }, Cmd.none )

        DeleteUser userId ->
            ( { model | club = RemoteData.Loading }, deleteUserFromClub model.clubId userId )

        UserDeleted _ ->
            ( { model | club = RemoteData.Loading }, fetchClub model.clubId )


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
                [ div [ class "grid grid-cols-4" ] content
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

        id =
            case club.id of
                Just (Id value) ->
                    value

                Nothing ->
                    "0"
    in
    div [ class "flex col-span-4 justify-center font-bold text-4xl text-yellow-500" ]
        [ h1 [] [ text ("Club: " ++ name ++ " (" ++ id ++ ")") ]
        ]


viewClubData : ClubData -> Html Msg
viewClubData model =
    div []
        [ div [ class "col-span-8" ]
            [ h1 [ class "font-bold" ]
                [ text "Club information"
                ]
            , button [ class "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded", onClick (FetchClub (Maybe.withDefault (Id "0") model.id)) ] [ text "refetch" ]
            ]
        , div []
            [ h1 [] [ text "Users list" ]
            , div
                [ class "flex grid-cols-8 gap-4" ]
                (viewClubUsersData model.users)
            ]
        ]


viewClubUsersData : Maybe (List (Maybe UserData)) -> List (Html Msg)
viewClubUsersData users =
    case users of
        Just actualUsers ->
            List.map viewUser actualUsers

        Nothing ->
            [ div [] [ text "No users for this club" ] ]


viewUser : Maybe UserData -> Html Msg
viewUser userData =
    case userData of
        Just actualUser ->
            div [ class "bg-gradient-to-r from-indigo-500 shadow-lg" ]
                [ text (Maybe.withDefault "--" actualUser.name)
                , button [ onClick (DeleteUser (Maybe.withDefault (Id "0") actualUser.id)), class "bg-gradient-to-r from-green-400 to-blue-500 hover:from-pink-500 hover:to-yellow-500" ]
                    [ text "x" ]
                ]

        Nothing ->
            div [] [ text "no user" ]
