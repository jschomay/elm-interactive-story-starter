module Theme.TitlePage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown exposing (..)


view : msg -> Html msg
view msg =
    div [ class "TitlePage" ]
        [ h1 [ class "TitlePage__Title" ] [ text "The Very Short Adventures of Bartholomew Barrymore featuring: The mystery of the missing marbles" ]
        , h3 [ class "TitlePage__Byline" ] [ text "B. B." ]
        , toHtml [ class "TitlePage__Prologue markdown-body" ] """Bartholomew Barrymore is at it again, using his fantastic deductive skills to solve the most intriguing of mysteries.
        ![](Theme/img/cottage.jpg)
        """
        , span [ class "TitlePage__StartGame", onClick msg ] [ text "Play" ]
        ]
