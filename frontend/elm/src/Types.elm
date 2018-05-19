module Types exposing (..)

import RemoteData exposing (WebData)


-- MODEL


type PlaybackState
    = Playing
    | Paused


type alias AudioTrack =
    { state : PlaybackState
    , volume : Int
    }


type alias Tracks =
    { whiteNoise : WebData AudioTrack
    }


type alias Model =
    { tracks : Tracks
    }



-- MESSAGES


type alias Id =
    String


type Msg
    = Play Id
    | Pause Id
    | IncreaseVolume Id Int
    | DecreaseVolume Id Int
