module ShowText where
import XMonad
import Data.Map.Strict
import XMonad.Actions.EasyMotion 
import XMonad.Actions.ShowText
import XMonad.Layout.ShowWName
-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
flash :: String -> X ()
flash text =
  flashText myTextConfig 1 (" " ++ text ++ " ")

myTextConfig :: ShowTextConfig
myTextConfig =
  STC
    { st_font = "xft:Ubuntu:weight=bold:pixelsize=128",
      st_bg = "#212733",
      st_fg = "#b7bdf8"
    }

emConf :: EasyMotionConfig
emConf =
  def
    { sKeys = PerScreenKeys $ fromList [(0, [xK_f, xK_d, xK_s, xK_a]), (1, [xK_h, xK_j, xK_k, xK_l])],
      txtCol = "#b7bdf8",
      bgCol = "#212733",
      borderCol = "#F28FAD",
      emFont = "xft:Ubuntu:weight=bold:pixelsize=128",
      borderPx = 6,
      overlayF = proportional 0.35
    }

myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Ubuntu:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#232634",
      swn_color = "#cdd6f4"
    }
