module Main where
import Keys (myKeys, myMouseBindings)
import Layout (myLayout)
import Log (mySB)
import Preferences (myTerminal, windowsKey)
import Startup (myStartup)
import WindowRules (myHandle, myManage)
import Workspaces (myWorkspaces)
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (docks, manageDocks)
import XMonad.Hooks.StatusBar (withSB)
---------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
main :: IO ()
main = do
  xmonad . ewmh . ewmhFullscreen . docks . withSB (mySB "xmobar") $
    def
      { manageHook = myManage,
        modMask = windowsKey,
        normalBorderColor = "#E8A2AF",
        focusFollowsMouse = False,
        focusedBorderColor = "#643FFF",
        keys = myKeys,
        mouseBindings = myMouseBindings,
        layoutHook = myLayout,
        workspaces = myWorkspaces,
        terminal = myTerminal,
        borderWidth = 0,
        handleEventHook = myHandle,
        startupHook = myStartup
      }
