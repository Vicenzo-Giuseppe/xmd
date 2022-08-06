module Main where
import Keys
import Layout
import Preferences
import Startup
import StatusBar
import WindowRules
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDebug
import XMonad.Hooks.UrgencyHook
---------------------------------------------------------------------
-- main
---------------------------------------------------------------------
main :: IO ()
main = do
  xmonad . ewmh . ewmhFullscreen . debugManageHookOn "M4-<Page_Up>" . docks . withSB (mySB "xmobar"). withUrgencyHook NoUrgencyHook $
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
