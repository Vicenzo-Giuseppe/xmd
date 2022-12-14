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
  copiesPP (xmobarColor "#f9e2af" "" . \s -> "<fn=2>\63099</fn>")
   $ def
    { ppCurrent = xmobarColor "#643FFF" "" . \s -> "<fn=2>\63202</fn>",
      ppHidden = xmobarColor "#F28FAD" "" . \s -> "<fn=2>\63255</fn>",
      ppHiddenNoWindows = xmobarColor "#00ffd0" "" . \s -> "<fn=4>\61713</fn>",
      ppUrgent = xmobarColor "#74c7ec" "" . \s -> "<fn=2>\63189</fn>",
      ppTitle = xmobarColor "#F28FAD" "" . shorten 65 ,
      ppSep = "  ",
      ppOrder = \[ws, l, t] -> [ws, t, l]
    }

mySB :: FilePath -> SB.StatusBarConfig
mySB xmobarPath = (SB.statusBarProp xmobarPath myPP)
    { SB.sbCleanupHook = SB.killAllStatusBars
    , SB.sbStartupHook = SB.killAllStatusBars >> SB.spawnStatusBar xmobarPath
    }

myXMobar :: StatusBarConfig
myXMobar = statusBarProp "xmobar" myPP


