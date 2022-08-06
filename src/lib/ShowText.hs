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
  flashText myFlashC 0.7 (" " ++ text ++ " ")

flash' :: String -> X ()
flash' text =
  flashText myFlashC' 0.7 (" " ++ text ++ " ")

warn :: String -> X ()
warn text =
  flashText myWarnC 0.7 (" " ++ text ++ " ")

warn' :: String -> X ()
warn' text =
  flashText myWarnC' 0.7 (" " ++ text ++ " ")

myFlashC :: ShowTextConfig
myFlashC =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=128",
      st_bg = "#212733",
      st_fg = "#F28FAD"
    }
myFlashC' :: ShowTextConfig
myFlashC' =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=128",
      st_bg = "#212733",
      st_fg = "#95e6cb"
    }

myWarnC :: ShowTextConfig
myWarnC =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=88",
      st_bg = "#a6adc8",
      st_fg = "#f9e2af"
    }
myWarnC' :: ShowTextConfig
myWarnC' =
  STC
    { st_font = "xft:Agave:weight=bold:pixelsize=88",
      st_bg = "#45475a",
      st_fg = "#89dceb"
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
