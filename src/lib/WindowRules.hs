module WindowRules where

import Data.Maybe (isJust)
import Preferences(myAPITestManager, myFileManager, myTelegram, myTerminal)
import Workspaces(myWorkspaces)
import XMonad
import XMonad.Hooks.FloatNext (floatNextHook)
import XMonad.Hooks.InsertPosition (Focus (Newer), Position (End), insertPosition)
import qualified XMonad.Hooks.ManageDocks as ManageDocks
import qualified XMonad.Hooks.ManageHelpers as ManageHelpers
import XMonad.Layout.NoBorders (hasBorder)
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
    ( NamedScratchpad(NS), customFloating, namedScratchpadManageHook )


myManageHook :: ManageHook
myManageHook =
  composeAll
    [ ManageDocks.manageDocks,
      -- open windows at the end if they are not floating
      fmap not checkModal --> insertPosition End Newer,
      floatNextHook,
      myManageHook'
    ]

checkModal :: Query Bool
checkModal = ManageHelpers.isInProperty "_NET_WM_STATE" "_NET_WM_STATE_MODAL"

checkSkipTaskbar :: Query Bool
checkSkipTaskbar = ManageHelpers.isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR"

myManageHook' :: ManageHook
myManageHook' =
  composeAll
    . concat
    $ [ [ManageHelpers.transience'], -- move transient windows like dialogs/alerts on top of their parents
        [className =? c --> doFloat | c <- myClassFloats],
        [className =? c --> ManageHelpers.doFullFloat | c <- myFullFloats],
        [className =? c --> doIgnore <+> hasBorder False | c <- myIgnores],
        [title =? t --> doFloat | t <- myTitleFloats],
        [className =? c --> ManageHelpers.doCenterFloat | c <- myCenterFloats],
        [title =? t --> ManageHelpers.doCenterFloat | t <- myTitleCenterFloats],
        [className =? c --> doShift ([" web ", " dev ", " docs ", " media ", " download ", " game ", " term ", " term2 ", " term3 ", " konsole "] !! ws) | (c, ws) <- myShifts],
        [title =? c --> doShift ([" web ", " dev ", " docs ", " media ", " download ", " game ", " term ", " term2 ", " term3 ", " konsole "] !! ws) | (c, ws) <- myTitleShifts],
        [className =? c --> hasBorder False | c <- myClassNoBorder],
        [role =? r --> ManageHelpers.doCenterFloat | r <- myRoleCenterFloats],
        [(className =? "firefox" <&&> resource =? "Dialog") --> doFloat], -- Float Firefox Dialog
        [ManageHelpers.isFullscreen --> ManageHelpers.doFullFloat],
        [ManageHelpers.isDialog --> doFloat],
        [namedScratchpadManageHook myScratchPads],
        [checkModal --> ManageHelpers.doCenterFloat],
        [(className =? "plasmashell" <&&> checkSkipTaskbar) --> doIgnore <+> hasBorder False] -- Ignore kde widgets
      ]
  where
    role = stringProperty "WM_WINDOW_ROLE"
    myIgnores = ["lattedock"]
    myCenterFloats =
      []
    myTitleCenterFloats =
      [ "File Operation Progress",
        "Downloads",
        "Save as..."
      ]
    myClassFloats =
      [ "confirm",
        "file_progress",
        "dialog",
        "download",
        "error",
        "Save As...",
        "notification",
        "float-window"
      ]
    myRoleCenterFloats = ["GtkFileChooserDialog"]
    myTitleFloats = ["Media viewer"]
    myFullFloats = []
    myShifts =
      [ ("firefox", 0),
        ("Brave-browser", 2),
        ("Alacritty", 1),
        ("konsole", 9),
        ("Darktable", 3),
        ("Mailspring", 3),
        ("7DaysToDie.x86_64", 5),
        ("Transmission-gtk", 4),
        ("Whatstux", 3)
      ]
    myTitleShifts =
      []
    myClassNoBorder =
      []

myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "discord" "discord" (appName =? "discord") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "spotify" "spotify" (appName =? "spotify") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "telegram" myTelegram (title =? "Telegram") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "insomnia" myAPITestManager (title =? "Insomnia") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "vieb" "vieb" (title =? "Vieb") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "dolphin" myFileManager (className =? "dolphin") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7),
    NS "terminal" launchTerminal (appName =? "float-window") (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7)
  ]
  where
    launchTerminal = myTerminal ++ " --class float-window"
