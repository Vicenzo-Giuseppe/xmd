module Layout where
import Preferences
import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.Simplest
import XMonad.Layout.LayoutModifier
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Hooks.ManageDocks (ToggleStruts (..), avoidStruts, docksEventHook, manageDocks)
import XMonad.Actions.MouseResize
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.Renamed
import XMonad.Layout.LimitWindows
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Magnifier
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders
------------------------------------------------------------------------
-- Space between Tiling Windows
------------------------------------------------------------------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 10 10 10) True (Border 10 10 10 10) True
------------------------------------------------------------------------
-- Layout Hook
------------------------------------------------------------------------
myLayoutHook =
  avoidStruts $
    mouseResize $
        windowArrange $
          T.toggleLayouts full $
            mkToggle (NBFULL ?? NOBORDERS ?? MIRROR ?? EOT) myDefaultLayout
  where
    myDefaultLayout =
      grid
        ||| full
        ||| Layout.magnify
        ||| mirror
        ||| tabs
------------------------------------------------------------------------
-- Tiling Layouts
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
mirror =
  renamed [Replace " <fc=#b7bdf8><fn=2> \62861 </fn>Mirror</fc>"] $
    smartBorders $
      windowNavigation $
        subLayout [] (smartBorders Simplest) $
          limitWindows 6 $
            mySpacing 5 $
              Mirror $
                ResizableTall 1 (3 / 100) (1 / 2) []
full =
  renamed [Replace " <fc=#b7bdf8><fn=2> \62556 </fn>Full</fc>"] $
    Full
magnify =
  renamed [Replace " <fc=#b7bdf8><fn=2> \61618 </fn>Magnify</fc>"] $
    magnifier $
      limitWindows 12 $
        mySpacing 8 $
          ResizableTall 1 (3 / 100) (1 / 2) []
tabs =
  renamed [Replace "<fc=#b7bdf8><fn=2> \62162 </fn>Tabs</fc>"] $
    tabbed shrinkText myTabConfig
  where
    myTabConfig =
      def
        { fontName = myFont ++ "regular:pixelsize=11",
          activeColor = "#292d3e",
          inactiveColor = "#3e445e",
          activeBorderColor = "#292d3e",
          inactiveBorderColor = "#292d3e",
          activeTextColor = "#ffffff",
          inactiveTextColor = "#d0d0d0"
}
