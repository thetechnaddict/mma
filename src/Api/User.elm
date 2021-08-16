module Api.User exposing (..)

{-|

@docs User, UserFull, Email

-}


type alias User =
    { id : Int
    , email : Email
    , username : String
    }


type alias UserFull =
    { id : Int
    , email : Email
    , username : String
    , password : String
    }


type alias UserId =
    Int


toUser : UserFull -> User
toUser u =
    { id = u.id
    , email = u.email
    , username = u.username
    }


type alias Email =
    String
