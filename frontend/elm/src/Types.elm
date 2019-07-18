module Types exposing (AudioTrack, Id, KeyDownMsg(..), Model, Msg(..), PlaybackState(..), Tracks, keyEvents)

import Dict exposing (Dict)
import Keyboard
import RemoteData exposing (WebData)
import Types.CyclicList exposing (CyclicList)
import Types.Theme exposing (Theme)
import Types.UnitInterval exposing (UnitInterval)



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
    , themes : CyclicList Theme
    }



-- MESSAGES


type alias Id =
    String


type Msg
    = KeyDown Char


type KeyDownMsg
    = CycleThemeForward
    | CycleThemeBackward


keyEvents : Dict Char KeyDownMsg
keyEvents =
    Dict.singleton 'T' CycleThemeForward
        |> Dict.insert 'N' CycleThemeBackward



-- TODO: add these later
-- | Play Id
-- | Pause Id
-- | IncreaseVolume Id Int
-- | DecreaseVolume Id Int
