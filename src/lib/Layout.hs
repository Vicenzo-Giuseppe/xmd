module Layout where
import Preferences
import ShowText
import qualified XMonad.Layout.ToggleLayouts as T
import XMonad
import XMonad.Actions.MouseResize
import XMonad.Hooks.ManageDocks
import XMonad.Layout.GridVariants
import XMonad.Layout.LayoutModifier 
import XMonad.Layout.LimitWindows 
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ShowWName
------------------------------------------------------------------------
-- space between tiling windows
------------------------------------------------------------------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 10 10 10) True (Border 10 10 10 10) True
------------------------------------------------------------------------
-- layout hook
------------------------------------------------------------------------

myLayout = showWName' myShowWNameTheme myLayout'

myLayout' =
  avoidStruts $
    mouseResize $
      windowArrange $
        T.toggleLayouts full $
          mkToggle (NBFULL ?? NOBORDERS ?? MIRROR ?? EOT) myDefaultLayout
  where
    myDefaultLayout =
      grid
        ||| full
------------------------------------------------------------------------
-- layouts
------------------------------------------------------------------------
grid =
  renamed [Replace " <fc=#b7bdf8><fn=2> \61449 </fn>Grid</fc>"] $
    smartBorders $
      windowNavigation $
        subLayout [] (smartBorders Simplest) $
          limitWindows 12 $
            mySpacing 5 $
              mkToggle (single MIRROR) $
                Grid (16 / 10)
full =
  renamed
    [Replace " <fc=#b7bdf8><fn=2> \62556 </fn>Full</fc>"]
    Full

