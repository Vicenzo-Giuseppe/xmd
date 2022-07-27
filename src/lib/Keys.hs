module Keys where
import Preferences
import Log
import Prompt
import WindowRules
import XMonad
import Data.Maybe (isJust)
import Graphics.X11.ExtraTypes.XF86
import System.IO (hPutStrLn)
import System.Exit
import Control.Arrow (first)
import XMonad.Actions.CycleWS
import XMonad.Layout.Spacing
import XMonad.Util.Run (runInTerm)
import XMonad.Util.NamedScratchpad
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.WithAll (killAll, sinkAll)
import qualified Data.Map as M
import XMonad.Prompt.DirExec
import XMonad.Actions.CycleWS (WSType (EmptyWS,WSIs), anyWS, moveTo, nextWS, shiftTo)
import XMonad.Prompt.Shell (shellPrompt)
import qualified XMonad.StackSet as W
import XMonad.Actions.Search
import XMonad.Actions.CopyWindow (runOrCopy, copy, killAllOtherCopies, copyToAll)
import XMonad.Actions.EasyMotion (selectWindow)
import XMonad.Actions.TiledWindowDragging
------------------------------------------------------------------------
-- Keys
------------------------------------------------------------------------
myKeys :: XConfig l0 -> M.Map (ButtonMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = windowsKey}) =
  M.fromList $
    map
      (first $ (,) windowsKey) -- WindowsKey + <Key>
      [ (xK_q, kill1),
        (xK_w, spawn myWebBrowser),
        (xK_e, spawn myTerminal),
        (xK_r, spawn xmonadRestart >> spawn raiseXMobar),
        (xK_t, sinkAll),
        (xK_a, spawn myFileManager),
     -- (xK_s, promptSearchBrowser browserXPConfig myWebBrowser mySearchEngines),
        (xK_s, selectWindow emConf >>= (`whenJust` windows . W.focusWindow)),
        (xK_d, spawn myEmail),
        (xK_f, spawn myTorrent),
        (xK_g, spawn myVM),
        (xK_z, shellPrompt xPromptConfig),
        (xK_x, dirExecPromptNamed xPromptConfig spawn "/home/vicenzo/.sh/" "Run:Scripts $ "),
        (xK_v, spawn myPhotoEditor),
        (xK_Tab, nextWS),
        (xK_space, sendMessage NextLayout),
        (xK_comma, windows W.focusDown),
        (xK_period, windows W.focusUp)
      ]
      ++ map
        (first $ (,) (windowsKey .|. shiftMask)) -- WindowsKey + ShiftKey + <Key>
        [ (xK_q, killAll),
          (xK_w, runOrCopy myWebBrowser (className =? "firefox")),
          (xK_e, runOrCopy myTerminal (className =? "Alacritty")),
          (xK_a, calcPrompt calcXPConfig "="),
          (xK_s, spawn mySpotify),
          (xK_d, spawn myAPITestManager),
          (xK_Escape, io exitSuccess),
          (xK_Tab, shiftTo Next anyWS)
        ]
      ++ map
        (first $ (,) controlMask) -- Control + <Key>
        [ (xK_comma, decWindowSpacing 4),
          (xK_period, incWindowSpacing 4)
        ]
      ++ map
        (first $ (,) shiftMask) -- Shift + <Key>
        []
      ++ map
        (first $ (,) mod1Mask) -- Alt + <Key>
        [ (xK_q, spawn myTelegram),
          (xK_w, spawn myDocsBrowser),
          (xK_r, spawn myWhatsapp),
          (xK_d, spawn "discord"),       
          (xK_z, killAllOtherCopies),
          (xK_x, windows copyToAll),
          (xK_e, namedScratchpadAction myScratchPads "terminal")
        ]
      ++ map
        (first $ (,) 0) -- Only <Key>
        [ (xF86XK_AudioMute, spawn "amixer -q set Master toggle"),
          (xF86XK_AudioLowerVolume, spawn "amixer -q set Master 10%-"),
          (xF86XK_AudioRaiseVolume, spawn "amixer -q set Master 10%+"),
          (xF86XK_MonBrightnessUp, spawn "xbacklight -inc 5"),
          (xF86XK_MonBrightnessDown, spawn "xbacklight -dec 5"),
          (xF86XK_AudioPlay, spawn "playerctl play-pause"),
          (xF86XK_AudioNext, spawn "playerctl next"),
          (xF86XK_AudioPrev, spawn "playerctl previous"),
          (xF86XK_AudioStop, spawn "playerctl stop"),
          (xK_Print, spawn takeScreenShot)
        ]
      ++ [ ((shift .|. windowsKey, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0], -- WindowsKey + 1 .. 5 # Go to WorkSpace
             (f, shift) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, mod1Mask)]]
      ++ [ ((shift .|. mod1Mask, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0], -- WindowsKey + 1 .. 5 # Go to WorkSpace
             (f, shift) <- [(copy, mod1Mask)]]
      ++ [ ((windowsKey, xK_c), dirExecPromptNamed xPromptConfig fn "/home/vicenzo/.sh/" "RunTerminal:Scripts $ ") | (fn) <- [(runInTerm " --hold ")]
         ]
  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
    runTerminal = myTerminal ++ " --hold -e "
-----------------------------------------------------------------------
-- MouseBindings
------------------------------------------------------------------------
myMouseBindings conf@(XConfig {XMonad.modMask = windowsKey}) =
  M.fromList $
    map
      (first $ (,) windowsKey) --  WindowsKey + <Key>
      [ (button1, \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster),
        (button2, \w -> focus w >> selectWindow emConf >>= (`whenJust` windows . W.focusWindow)),
        (button3, \w -> focus w >> windows W.shiftMaster)
      ] 
