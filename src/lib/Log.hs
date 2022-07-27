module Log where
import XMonad.Hooks.StatusBar 
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Run
import XMonad.Actions.CopyWindow
import XMonad.Actions.EasyMotion (selectWindow, EasyMotionConfig(..), ChordKeys(PerScreenKeys), proportional)
import qualified Data.Map.Strict as StrictMap (fromList)
import Graphics.X11.Types
------------------------------------------------------------------------
-- 
------------------------------------------------------------------------
myPP = def { 
                    ppCurrent = xmobarColor "#643FFF" "" . \s -> "<fn=2>\61832</fn>",
                    ppHidden = xmobarColor "#F28FAD" "" . \s -> " <fn=10>\61713</fn>",
                    ppHiddenNoWindows = xmobarColor "#00ffd0" "" . \s -> " <fn=5>\61713</fn>",
                    ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t] ,
                    ppTitle = xmobarColor "#F28FAD" "" . shorten 55,
                    ppSep = "<fc=#212733>  <fn=1> </fn> </fc>"
           }


emConf :: EasyMotionConfig
emConf = def {
       sKeys = PerScreenKeys $ StrictMap.fromList [(0, [xK_f, xK_d, xK_s, xK_a]), (1, [xK_h, xK_j, xK_k, xK_l])],
       txtCol = "#b7bdf8",
       bgCol = "#212733",
       borderCol = "#F28FAD",
       emFont = "xft:Ubuntu:weight=bold:pixelsize=128",
       borderPx = 6,
       overlayF = proportional 0.35
     }
