module Pages.Login exposing (Model, Msg(..), page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Bridge exposing (..)
import Css
import Effect exposing (Effect)
import Gen.Route as Route
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Events as Events
import Page
import Request exposing (Request)
import Shared
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Utils.Route
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init shared
        , update = update req
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { user : Data User
    , email : String
    , password : String
    }


init : Shared.Model -> ( Model, Effect Msg )
init shared =
    ( Model
        (case shared.user of
            Just user ->
                Api.Data.Success user

            Nothing ->
                Api.Data.NotAsked
        )
        ""
        ""
    , Effect.none
    )



-- UPDATE


type Msg
    = Inputed Field String
    | AttemptedSignIn
    | GotUser (Data User)


type Field
    = Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Inputed Email email ->
            ( { model | email = email }
            , Effect.none
            )

        Inputed Password password ->
            ( { model | password = password }
            , Effect.none
            )

        AttemptedSignIn ->
            ( model
            , (Effect.fromCmd << sendToBackend) <|
                UserAuthentication_Login
                    { params =
                        { email = model.email
                        , password = model.password
                        }
                    }
            )

        GotUser user ->
            case Api.Data.toMaybe user of
                Just user_ ->
                    ( { model | user = user }
                    , Effect.batch
                        [ Effect.fromCmd (Utils.Route.navigate req.key Route.Home_)
                        , Effect.fromShared (Shared.SignedIn user_)
                        ]
                    )

                Nothing ->
                    ( { model | user = user }
                    , Effect.none
                    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign in"
    , body =
        [ viewLoginForm model ]
    }


viewLoginForm : Model -> Html Msg
viewLoginForm model =
    div
        [ css
            [ Tw.min_h_screen
            , Tw.bg_gray_100
            , Tw.flex
            , Tw.flex_col
            , Tw.justify_center
            , Tw.neg_mt_10 --to take into account the height of the header
            , Bp.lg
                [ Tw.px_8
                ]
            , Bp.sm
                [ Tw.px_6
                ]
            ]
        ]
        [ div
            [ css
                [ Bp.sm
                    [ Tw.mx_auto
                    , Tw.w_full
                    , Tw.max_w_md
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.bg_white
                    , Tw.py_8
                    , Tw.px_4
                    , Tw.shadow
                    , Bp.sm
                        [ Tw.rounded_lg
                        , Tw.px_10
                        ]
                    ]
                ]
                [ form
                    [ css
                        [ Tw.space_y_6
                        ]
                    , Events.onSubmit AttemptedSignIn
                    ]
                    [ div []
                        [ label
                            [ Attr.for "email"
                            , css
                                [ Tw.block
                                , Tw.text_sm
                                , Tw.font_medium
                                , Css.important Tw.text_gray_700
                                ]
                            ]
                            [ text "Email address" ]
                        , div
                            [ css
                                [ Tw.mt_1
                                ]
                            ]
                            [ input
                                [ Attr.id "email"
                                , Attr.name "email"
                                , Attr.type_ "email"
                                , Attr.attribute "autocomplete" "email"
                                , Attr.required True
                                , Attr.value model.email
                                , Events.onInput <| Inputed Email
                                , css
                                    [ Css.important Tw.appearance_none
                                    , Css.important Tw.block
                                    , Css.important Tw.w_full
                                    , Css.important Tw.px_3
                                    , Css.important Tw.py_2
                                    , Css.important Tw.border
                                    , Css.important Tw.border_gray_300
                                    , Css.important Tw.rounded_md
                                    , Css.important Tw.shadow_sm
                                    , Css.important Tw.placeholder_gray_400
                                    , Css.focus
                                        [ Css.important Tw.outline_none
                                        , Css.important Tw.ring_yellow_500
                                        , Css.important Tw.border_yellow_500
                                        ]
                                    , Bp.sm
                                        [ Tw.text_sm
                                        ]
                                    ]
                                ]
                                []
                            ]
                        ]
                    , div []
                        [ label
                            [ Attr.for "password"
                            , css
                                [ Tw.block
                                , Tw.text_sm
                                , Tw.font_medium
                                , Tw.text_gray_700
                                ]
                            ]
                            [ text "Password" ]
                        , div
                            [ css
                                [ Tw.mt_1
                                ]
                            ]
                            [ input
                                [ Attr.id "password"
                                , Attr.name "password"
                                , Attr.type_ "password"
                                , Attr.attribute "autocomplete" "current-password"
                                , Attr.required True
                                , Attr.value model.password
                                , Events.onInput <| Inputed Password
                                , css
                                    [ Tw.appearance_none
                                    , Tw.block
                                    , Tw.w_full
                                    , Tw.px_3
                                    , Tw.py_2
                                    , Tw.border
                                    , Css.important Tw.border_gray_300
                                    , Css.important Tw.rounded_md
                                    , Css.important Tw.shadow_sm
                                    , Css.important Tw.placeholder_gray_400
                                    , Css.focus
                                        [ Css.important Tw.outline_none
                                        , Css.important Tw.ring_yellow_500
                                        , Css.important Tw.border_yellow_500
                                        ]
                                    , Bp.sm
                                        [ Tw.text_sm
                                        ]
                                    ]
                                ]
                                []
                            ]
                        ]
                    , div
                        [ css
                            [ Tw.flex
                            , Tw.items_center
                            , Tw.justify_between
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.text_sm
                                ]
                            ]
                            [ a
                                [ Attr.href "#"
                                , css
                                    [ Tw.font_medium
                                    , Tw.text_yellow_600
                                    , Css.hover
                                        [ Tw.text_yellow_500
                                        ]
                                    ]
                                ]
                                [ text "Forgot your password?" ]
                            ]
                        ]
                    , div []
                        [ button
                            [ Attr.type_ "submit"
                            , css
                                [ Tw.w_full
                                , Tw.flex
                                , Tw.justify_center
                                , Tw.py_2
                                , Tw.px_4
                                , Tw.border
                                , Tw.border_transparent
                                , Tw.rounded_md
                                , Tw.shadow_sm
                                , Tw.text_sm
                                , Tw.font_medium
                                , Tw.text_white
                                , Tw.bg_yellow_600
                                , Css.focus
                                    [ Tw.outline_none
                                    , Tw.ring_2
                                    , Tw.ring_offset_2
                                    , Tw.ring_yellow_500
                                    ]
                                , Css.hover
                                    [ Tw.bg_yellow_700
                                    ]
                                ]
                            ]
                            [ text "Sign in" ]
                        ]
                    ]
                ]
            ]
        ]
