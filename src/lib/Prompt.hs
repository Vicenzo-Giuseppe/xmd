module Prompt where

import Control.Arrow (first)
import Data.Char (isSpace)
import qualified Data.Map as M
import Preferences ( myFont )
import XMonad
import qualified XMonad.Actions.Search as S
import XMonad.Layout.TabBarDecoration
    ( XPPosition(CenteredAt, Top, xpCenterY, xpWidth) )
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch ( fuzzyMatch )
import XMonad.Prompt.Input ( (?+), inputPrompt )
import qualified XMonad.StackSet as W
import XMonad.Util.Run (runProcessWithInput)

------------------------------------------------------------------------
-- XPrompt
------------------------------------------------------------------------
xPromptConfig :: XPConfig
xPromptConfig =
  def
    { font = myFont ++ "bold:size=16",
      bgColor = "#643FFF",
      fgColor = "#E8A2AF",
      bgHLight = "#FFFFFF",
      fgHLight = "#89DCEB",
      borderColor = "#535974",
      promptBorderWidth = 0,
      promptKeymap = xPromptKeymap,
      position = Top,
      height = 36,
      historySize = 256,
      historyFilter = id,
      defaultText = [],
      autoComplete = Just 100000,
      showCompletionOnTab = False,
      searchPredicate = fuzzyMatch,
      alwaysHighlight = True,
      maxComplRows = Nothing
    }

browserXPConfig :: XPConfig
browserXPConfig =
  xPromptConfig
    { font = myFont ++ "bold:size=20",
      autoComplete = Nothing,
      height = 36,
      bgHLight = "#FFFFFF",
      bgColor = "#e78284",
      fgColor = "#303446",
      position = CenteredAt {xpCenterY = 0.1, xpWidth = 0.3},
      historySize = 0
    }

calcXPConfig :: XPConfig
calcXPConfig =
  xPromptConfig
    { font = myFont ++ "bold:size=30",
      autoComplete = Nothing,
      height = 64,
      position = CenteredAt {xpCenterY = 0.3, xpWidth = 0.3},
      bgColor = "#babbf1",
      fgColor = "#292c3c",
      historySize = 0
    }

calcPrompt :: XPConfig -> String -> X ()
calcPrompt c ans =
  inputPrompt c (trim ans) ?+ \input ->
    liftIO (runProcessWithInput "qalc" [input] "") >>= calcPrompt c
  where
    trim = f . f
      where
        f = reverse . dropWhile isSpace

archwiki, news, reddit, youtube, google :: S.SearchEngine
archwiki = S.searchEngine "aw" "https://wiki.archlinux.org/index.php?search="
news = S.searchEngine "n" "https://news.google.com/search?q="
reddit = S.searchEngine "r" "https://www.reddit.com/search/?q="
youtube = S.searchEngine "yt" "https://www.youtube.com/results?search_query="
google = S.searchEngine "gg" "https://www.google.com/search?q="

mySearchEngines :: S.SearchEngine
mySearchEngines =
  S.namedEngine
    "firefox"
    $ foldr1
      (S.!>)
      [ archwiki,
        news,
        reddit,
        youtube,
        google,
        S.wikipedia
      ]

xPromptKeymap :: M.Map (KeyMask, KeySym) (XP ())
xPromptKeymap =
  M.fromList $
    map
      (first $ (,) controlMask) -- control + <key>
      [ (xK_z, killBefore), -- kill line backwards
        (xK_k, killAfter), -- kill line forwards
        (xK_a, startOfLine), -- move to the beginning of the line
        (xK_e, endOfLine), -- move to the end of the line
        (xK_m, deleteString Next), -- delete a character foward
        (xK_b, moveCursor Prev), -- move cursor forward
        (xK_f, moveCursor Next), -- move cursor backward
        (xK_BackSpace, killWord Prev), -- kill the previous word
        (xK_y, pasteString), -- paste a string
        (xK_g, quit), -- quit out of prompt
        (xK_bracketleft, quit)
      ]
      ++ map
        (first $ (,) mod1Mask) --  alt + <key>
        [ (xK_BackSpace, killWord Prev), -- kill the prev word
          (xK_f, moveWord Next), -- move a word forward
          (xK_b, moveWord Prev), -- move a word backward
          (xK_d, killWord Next), -- kill the next word
          (xK_n, moveHistory W.focusUp'), -- move up thru history
          (xK_p, moveHistory W.focusDown') -- move down thru history
        ]
      ++ map
        (first $ (,) 0) -- <key>
        [ (xK_Return, setSuccess True >> setDone True),
          (xK_KP_Enter, setSuccess True >> setDone True),
          (xK_BackSpace, deleteString Prev),
          (xK_Delete, deleteString Next),
          (xK_Left, moveCursor Prev),
          (xK_Right, moveCursor Next),
          (xK_Home, startOfLine),
          (xK_End, endOfLine),
          (xK_Down, moveHistory W.focusUp'),
          (xK_Up, moveHistory W.focusDown'),
          (xK_Escape, quit)
        ]
