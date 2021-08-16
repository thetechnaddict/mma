module Pages.Home_ exposing (Model, Msg, page)

import Api.User exposing (User)
import Effect exposing (Effect)
import Gen.Params.Home_ exposing (Params)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Page
import Request
import Shared
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.advanced
        (\user ->
            { init = init
            , update = update
            , view = view user
            , subscriptions = subscriptions
            }
        )



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : User -> Model -> View Msg
view user model =
    { title = "Homepage"
    , body =
        [ div
            [ css
                [ Tw.min_h_screen
                , Tw.bg_white
                ]
            ]
            [ header
                [ css
                    [ Tw.bg_gray_50
                    , Tw.overflow_hidden
                    , Tw.rounded_lg
                    , Tw.min_h_screen
                    ]
                ]
                [ div
                    [ css
                        [ Tw.px_4
                        , Tw.py_5
                        , Bp.sm
                            [ Tw.px_6
                            ]
                        ]
                    ]
                    []
                , main_
                    [ css
                        [ Tw.px_4
                        , Tw.min_h_full
                        , Tw.py_5
                        , Bp.sm
                            [ Tw.p_6
                            ]
                        ]
                    ]
                    [ viewWelcome
                    ]
                ]
            ]
        ]
    }


viewWelcome : Html msg
viewWelcome =
    div
        {--Hero Card --}
        [ css
            [ Tw.min_h_screen
            , Tw.max_w_5xl
            , Tw.mx_auto
            , Tw.flex
            , Tw.flex_col
            , Tw.justify_center
            , Tw.bg_gray_100
            , Tw.neg_mt_10 --to take into account the height of the header
            ]
        ]
        [ div
            [ css
                [ Tw.relative
                , Tw.shadow_xl
                , Tw.bg_white
                , Tw.pt_3
                , Bp.sm
                    [ Tw.rounded_2xl
                    , Tw.overflow_hidden
                    , Tw.pt_8
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.text_center
                    , Tw.mb_12
                    ]
                ]
                [ h1
                    [ css
                        [ Tw.text_4xl
                        , Tw.tracking_tight
                        , Tw.font_extrabold
                        , Tw.text_gray_900
                        , Bp.md
                            [ Tw.text_6xl
                            ]
                        , Bp.sm
                            [ Tw.text_5xl
                            ]
                        ]
                    ]
                    [ span
                        [ css
                            [ Tw.block
                            , Bp.xl
                                [ Tw.inline
                                ]
                            ]
                        ]
                        [ text "Welcome to all the" ]
                    , span
                        [ css
                            [ Tw.block
                            , Tw.text_yellow_600
                            , Bp.xl
                                [ Tw.inline
                                ]
                            ]
                        ]
                        [ text "Super Heroes" ]
                    ]
                ]
            ]
        ]
