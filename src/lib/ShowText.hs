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
  flashText myTextColor 0.7 (" " ++ text ++ " ")

flash' :: String -> X ()
flash' text =
  flashText myTextColor' 0.7 (" " ++ text ++ " ")

myTextColor :: ShowTextConfig
myTextColor =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=128",
      st_bg = "#212733",
      st_fg = "#F28FAD"
    }
myTextColor' :: ShowTextConfig
myTextColor' =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=128",
      st_bg = "#212733",
      st_fg = "#95e6cb"
    }



emConf :: EasyMotionConfig
emConf =
  def
    { sKeys = PerScreenKeys $ fromList [(0, [xK_a, xK_s, xK_d, xK_f]), (1, [xK_h, xK_j, xK_k, xK_l])],
      txtCol = "#f9e2af",
      bgCol = "#212733",
      borderCol = "#F28FAD",
      emFont = "xft:Ubuntu:weight=bold:pixelsize=128",
      borderPx = 6,
      overlayF = proportional 0.35
    }

myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Agave:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#232634",
      swn_color = "#cdd6f4"
    }
