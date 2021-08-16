module Bridge exposing (..)

import Api.User exposing (User)
import Lamdera


sendToBackend : ToBackend -> Cmd frontendMsg
sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = SignedOut User
      -- Req/resp paired messages
    | UserAuthentication_Login { params : { email : String, password : String } }
    | NoOpToBackend