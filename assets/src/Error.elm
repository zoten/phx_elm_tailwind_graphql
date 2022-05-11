module Error exposing (buildErrorMessage, hackBuildErrorMessage)

import Graphql.Http
import Http


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


hackBuildErrorMessage : Graphql.Http.RawError parsedData Http.Error -> String
hackBuildErrorMessage httpError =
    case httpError of
        Graphql.Http.BadUrl message ->
            message

        Graphql.Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Graphql.Http.NetworkError ->
            "Unable to reach server."

        Graphql.Http.BadStatus _ message ->
            "Request failed with status code: " ++ message

        Graphql.Http.BadPayload _ ->
            "Bad payload"
