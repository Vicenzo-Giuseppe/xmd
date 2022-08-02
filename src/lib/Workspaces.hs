module Workspaces where
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad
import Data.Maybe (fromJust)
-----------------------------------------------------------------------
-- workspaces
------------------------------------------------------------------------
myWorkspaces =[" web ", " dev ", " docs ", " media ", " download ", " game ", " term ", " term2 ", " term3 ", " konsole "] 

myWorkspacesKeys = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1, 2, 3, 4, 5, 6, 7, 8, 9, 0] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices


