-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module API.Scmp.VerifyScalarCodecs exposing (..)

{-
   This file is intended to be used to ensure that custom scalar decoder
   files are valid. It is compiled using `elm make` by the CLI.
-}

import API.CustomCodecs
import API.Scmp.Scalar


verify : API.Scmp.Scalar.Codecs API.CustomCodecs.Id API.CustomCodecs.NaiveDateTime
verify =
    API.CustomCodecs.codecs
