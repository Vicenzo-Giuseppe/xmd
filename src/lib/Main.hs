module Main where
import Preferences 
import Log
import Keys
import WindowRules
import Workspaces
import Layout
import Startup
import XMonad.Hooks.ManageDocks
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Kde
import XMonad.Util.Run 
import XMonad.Hooks.ServerMode
import XMonad.Layout.ShowWName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Actions.CopyWindow 
---------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
main :: IO ()
main = do
  mySB <- statusBarPipe "xmobar" (copiesPP (pad . xmobarColor "#f9e2af" "" . \s -> "<fn=10>\61713</fn>") myPP)
  xmonad . ewmh . ewmhFullscreen . docks . withEasySB mySB defToggleStrutsKey $ def {
          manageHook = myManageHook <+> manageDocks,
          modMask = windowsKey,
          normalBorderColor = "#E8A2AF",
          focusFollowsMouse = False,
          focusedBorderColor = "#643FFF",
          keys = myKeys,
          mouseBindings = myMouseBindings,
          layoutHook = showWName' myShowWNameTheme $ myLayoutHook,
          workspaces = myWorkspaces,
          terminal = myTerminal,
          borderWidth = 0,    
          handleEventHook = serverModeEventHook <+> serverModeEventHookCmd <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn),
          startupHook = myStartupHook
}


