module StatusBar where
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad
import XMonad.Actions.CopyWindow 
import qualified XMonad.Hooks.StatusBar as SB
-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
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

mySB :: FilePath -> SB.StatusBarConfig
mySB xmobarPath = (SB.statusBarProp xmobarPath myPP)
    { SB.sbCleanupHook = SB.killAllStatusBars
    , SB.sbStartupHook = SB.killAllStatusBars >> SB.spawnStatusBar xmobarPath
    }

myXMobar :: StatusBarConfig
myXMobar = statusBarProp "xmobar" myPP


