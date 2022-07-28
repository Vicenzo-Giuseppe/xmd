{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}
module Log where
import qualified Data.Map.Strict as StrictMap (fromList)
import Graphics.X11.Types
import XMonad.Actions.EasyMotion (ChordKeys (PerScreenKeys), EasyMotionConfig (..), proportional, selectWindow)
import XMonad.Hooks.StatusBar (withEasySB, statusBarProp, StatusBarConfig, sbLogHook, sbStartupHook, sbCleanupHook )
import XMonad.Hooks.StatusBar.PP
  ( PP
      ( ppCurrent,
        ppExtras,
        ppHidden,
        ppHiddenNoWindows,
        ppOrder,
        ppSep,
        ppTitle
      ),
    def,
    shorten,
    xmobarColor
  )
import XMonad
import XMonad.Actions.CopyWindow ( copiesPP )
import qualified XMonad.Hooks.StatusBar as SB
-----------------------------------------------------------------------
--
------------------------------------------------------------------------
myPP :: X PP
myPP =
  copiesPP (xmobarColor "#f9e2af" "" . \s -> "<fn=10>\61713</fn>")
   $ def
    { ppCurrent = xmobarColor "#643FFF" "" . \s -> "<fn=2>\61832</fn>",
      ppHidden = xmobarColor "#F28FAD" "" . \s -> "<fn=10>\61713</fn>",
      ppHiddenNoWindows = xmobarColor "#00ffd0" "" . \s -> "<fn=5>\61713</fn>",
      ppTitle = xmobarColor "#F28FAD" "" . shorten 55,
      ppSep = "  "
    }

emConf :: EasyMotionConfig
emConf =
  def
    { sKeys = PerScreenKeys $ StrictMap.fromList [(0, [xK_f, xK_d, xK_s, xK_a]), (1, [xK_h, xK_j, xK_k, xK_l])],
      txtCol = "#b7bdf8",
      bgCol = "#212733",
      borderCol = "#F28FAD",
      emFont = "xft:Ubuntu:weight=bold:pixelsize=128",
      borderPx = 6,
      overlayF = proportional 0.35
    }

mySB :: FilePath -> SB.StatusBarConfig
mySB xmobarPath = (SB.statusBarProp xmobarPath myPP)
    { SB.sbCleanupHook = SB.killAllStatusBars
    , SB.sbStartupHook = SB.killAllStatusBars >> SB.spawnStatusBar xmobarPath
    }

