module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

--import Html exposing (..)
--import Html.Attributes as Attr

import Api.User exposing (User)
import Bridge exposing (..)
import Request exposing (Request)
import View exposing (View)



-- INIT


type alias Flags =
    ()


type alias Model =
    { user : Maybe User
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ json =
    ( Model Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = ClickedSignOut
    | SignedIn User


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignedIn user ->
            ( { model | user = Just user }
            , Cmd.none
            )

        ClickedSignOut ->
            ( { model | user = Nothing }
            , model.user |> Maybe.map (\user -> sendToBackend (SignedOut user)) |> Maybe.withDefault Cmd.none
            )



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title =
        if String.isEmpty page.title then
            "ChangeGame"

        else
            page.title ++ " | ChangeGame"
    , body = page.body
    }


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
