module Types exposing (..)

import OpaqueTypes.Theme exposing (Theme)
import OpaqueTypes.UnitInterval exposing (UnitInterval)
import RemoteData exposing (WebData)


-- MODEL


type PlaybackState
    = Playing
    | Paused


type alias AudioTrack =
    { state : PlaybackState
    , volume : UnitInterval
    }


type alias Tracks =
    { whiteNoise : WebData AudioTrack
    }


type alias Model =
    { tracks : Tracks
    , theme : Theme
    }



-- MESSAGES


type alias Id =
    String


type Msg
    = Play Id
    | Pause Id
    | IncreaseVolume Id Int
    | DecreaseVolume Id Int
    | ChangeTheme Theme
