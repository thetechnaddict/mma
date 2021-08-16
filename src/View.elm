module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Css.Global
import Html.Styled
import Tailwind.Utilities as Tw


type alias View msg =
    { title : String
    , body : List (Html.Styled.Html msg)
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , body = [ Html.Styled.text str ]
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , body = List.map (Html.Styled.map fn) view.body
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ Html.Styled.toUnstyled <|
            Html.Styled.div
                []
                [ Css.Global.global Tw.globalStyles
                , Html.Styled.div [] view.body
                ]
        ]
    }
