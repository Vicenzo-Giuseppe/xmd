module Main where
import Keys ( myKeys, myMouseBindings )
import Layout ( myLayoutHook )
import Log ( myPP )
import Preferences ( myTerminal, windowsKey )
import Startup ( myStartupHook )
import WindowRules ( myManageHook )
import Workspaces ( myShowWNameTheme, myWorkspaces )
import XMonad
import XMonad.Actions.CopyWindow ( copiesPP )
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhFullscreen )
import XMonad.Hooks.ManageDocks ( docks, manageDocks )
import XMonad.Hooks.ServerMode
    ( serverModeEventHook,
      serverModeEventHookCmd,
      serverModeEventHookF )
import XMonad.Hooks.StatusBar
    ( defToggleStrutsKey, statusBarPipe, withEasySB )
import XMonad.Hooks.StatusBar.PP ( pad, xmobarColor )
import XMonad.Layout.ShowWName ( showWName' )
---------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
main :: IO ()
main = do
  mySB <- statusBarPipe "xmobar" (copiesPP (pad . xmobarColor "#f9e2af" "" . \s -> "<fn=10>\61713</fn>") myPP)
  xmonad . ewmh . ewmhFullscreen . docks . withEasySB mySB defToggleStrutsKey $
    def
      { manageHook = myManageHook <+> manageDocks,
        modMask = windowsKey,
        normalBorderColor = "#E8A2AF",
        focusFollowsMouse = False,
        focusedBorderColor = "#643FFF",
        keys = myKeys,
        mouseBindings = myMouseBindings,
        layoutHook = showWName' myShowWNameTheme myLayoutHook,
        workspaces = [" web ", " dev ", " docs ", " media ", " download ", " game ", " term ", " term2 ", " term3 ", " konsole "],
        terminal = myTerminal,
        borderWidth = 0,
        handleEventHook = serverModeEventHook <+> serverModeEventHookCmd <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn),
        startupHook = myStartupHook
      }
