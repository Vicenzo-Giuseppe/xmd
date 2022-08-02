module Startup where
import Preferences
import XMonad.Hooks.SetWMName
import XMonad.Util.SpawnOnce
------------------------------------------------------------------------
-- Startup Hooks
------------------------------------------------------------------------
myStartup = do
  spawnOnce picomStart
  spawnOnce xmobarRaise
  setWMName "LG3D"
 where
  picomStart = "picom -b --animations --animation-window-mass 0.5 --animation-for-open-window zoom --animation-stiffness 350 --animation-for-transient-window zoom --config $HOME/xmd/src/.picom.conf"
  xmobarRaise = "sleep 3 && xdotool windowraise `xdotool search --all --name xmobar`"
