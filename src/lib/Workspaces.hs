module Workspaces where
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Layout.ShowWName
import qualified Data.Map as M
import Data.Maybe (fromJust)
-----------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------
myWorkspaces = [" web ", " dev ", " docs ", " media ", " download ", " game ", " term ", " term2 ", " term3 ", " konsole "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1,2,3,4,5,6,7,8,9,0] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
-----------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60"

  , swn_fade              = 1.0

  , swn_bgcolor           = "#232634"

  , swn_color             = "#cdd6f4"

  }
