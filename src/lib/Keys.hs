module Keys where
import StatusBar
import ShowText
import Preferences
import Prompt
import WindowRules
import Workspaces
import Control.Arrow
import qualified Data.Map as M
import Data.Maybe
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.EasyMotion
import XMonad.Actions.Plane
import XMonad.Actions.Search
import XMonad.Actions.WithAll
import XMonad.Hooks.StatusBar
import XMonad.Layout.Spacing
import XMonad.Prompt.DirExec
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W
import XMonad.Util.ActionCycle
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
------------------------------------------------------------------------
-- keys
------------------------------------------------------------------------
myKeys :: XConfig l0 -> M.Map (ButtonMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = windowsKey}) =
  M.fromList $
    map
      (first $ (,) windowsKey) -- WindowsKey + <Key>
      [ 
        (xK_q, kill1),
        (xK_w, s myWebBrowser),
        (xK_e, s myTerminal),
        (xK_r, sinkAll ),
        (xK_t, s myEmail),
        (xK_a, s myFileManager),
        (xK_s, windows W.focusDown),
        (xK_d, windows W.focusUp),
        (xK_f, s xmonadRestart >> s raiseXMobar),
        (xK_g, s myVM),
        (xK_z, prompt),
        (xK_x, cA "Open/Close-XMobar" [killXMobar, spawnXMobar]),
        (xK_v, s myPhotoEditor),
        (xK_Tab, nextWS),
        (xK_space, sendMessage NextLayout),
        (xK_comma, decWindowSpacing 4),
        (xK_period, incWindowSpacing 4)
      ]
      ++ map
        (first $ (,) (windowsKey .|. shiftMask)) -- WindowsKey + ShiftKey + <Key>
        [ (xK_q, killAll),
          (xK_w, rc myWebBrowser (c =? "firefox")),
          (xK_e, rc myTerminal (c =? "Alacritty")),
          (xK_a, calcPrompt'),
          (xK_s, s mySpotify),
          (xK_d, s myAPITestManager),
          (xK_Escape, s myTorrent),
          (xK_Tab, shiftTo Next anyWS),
          (xK_z, runScripts)
        ]
      ++ map
        (first $ (,) controlMask) -- Control + <Key>
        [
          (xK_space, promptSearchBrowser')
        ]
      ++ map
        (first $ (,) shiftMask) -- Shift + <Key>
        [
          (xK_space, vimMode)
        ]
    ++ map
        (first $ (,) mod1Mask) -- Alt + <Key>
        [ (xK_q, s myTelegram),
          (xK_w, s myDocsBrowser),
          (xK_r, s myWhatsapp),
          (xK_d, s "discord"),
          (xK_z, killAllOtherCopies),
          (xK_x, windows copyToAll),
          (xK_e, scratchTerminal)
        ]
      ++ map
        (first $ (,) 0) -- Only <Key>
        [ (xF86XK_AudioMute, s "amixer -q set Master toggle"),
          (xF86XK_AudioLowerVolume, s "amixer -q set Master 10%-"),
          (xF86XK_AudioRaiseVolume, s "amixer -q set Master 10%+"),
          (xF86XK_MonBrightnessUp, s "xbacklight -inc 5"),
          (xF86XK_MonBrightnessDown, s "xbacklight -dec 5"),
          (xF86XK_AudioPlay, s "playerctl play-pause"),
          (xF86XK_AudioNext, s "playerctl next"),
          (xF86XK_AudioPrev, s "playerctl previous"),
          (xF86XK_AudioStop, s "playerctl stop"),
          (xK_Print, s takeScreenShot)
        ]
      ++ goToWorkspace
      ++ copyToWorkspace
      ++ runScriptsInTerminal
      ++ navigationArrows
------------------------------------------------------------------------
--
------------------------------------------------------------------------
  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
    runTerminal = myTerminal ++ " --hold -e "
    s = spawn
    vimMode = selectWindow emConf >>= (`whenJust` windows . W.focusWindow)
    prompt = shellPrompt xPromptConfig
    runScripts = dirExecPromptNamed xPromptConfig s "/home/vicenzo/.sh/" "Run:Scripts $ "
    rc = runOrCopy
    c = className
    calcPrompt' = calcPrompt calcXPConfig "="
    cA = cycleAction
    scratchTerminal = namedScratchpadAction myScratchPads "terminal"
    promptSearchBrowser' = promptSearchBrowser browserXPConfig myWebBrowser mySearchEngines
    spawnXMobar = spawnStatusBar "xmobar" >> s raiseXMobar >> x' "OPEN"
    killXMobar = killAllStatusBars >> s "killall xmobar" >> x "CLOSE"
    x = flash
    x' = flash'
    navigationArrows = M.toList (planeKeys mod4Mask (Lines 1) Linear)
    goToWorkspace =
      [ ((shift .|. windowsKey, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) myWorkspacesKeys,
          (f, shift) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
    copyToWorkspace =
      [ ((shift .|. mod1Mask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) myWorkspacesKeys, -- WindowsKey + 1 .. 5 # Go to WorkSpace
          (f, shift) <- [(copy, mod1Mask)]
      ]
    runScriptsInTerminal = [((windowsKey .|. shiftMask, xK_c), dirExecPromptNamed xPromptConfig fn "/home/vicenzo/.sh/" "RunTerminal:Scripts $ ") | fn <- [runInTerm " --hold "]]
-----------------------------------------------------------------------
-- mousebindings
-----------------------------------------------------------------------
myMouseBindings conf@(XConfig {XMonad.modMask = windowsKey}) =
  M.fromList $
    map
      (first $ (,) windowsKey) --  WindowsKey + <Key>
      [ (button1, \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster),
        (button2, \w -> focus w >> selectWindow emConf >>= (`whenJust` windows . W.focusWindow)),
        (button3, \w -> focus w >> windows W.shiftMaster)
      ]

