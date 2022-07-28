module Preferences where

import XMonad

windowsKey = mod4Mask

------------------------------------------------------------------------
-- Programs
------------------------------------------------------------------------
myTerminal = "alacritty"

myWebBrowser = "/usr/bin/firefox"

myDocsBrowser = "/usr/bin/brave"

myFileManager = "dolphin"

myEmail = "mailspring"

myWhatsapp = "whatstux "

myTelegram = "telegram-desktop"

mySpotify = ""

myTorrent = "transmission-gtk"

myPhotoEditor = "darktable"

myVM = "vmware"

myAPITestManager = "insomnia"

myFont = "xft:mononoki Nerd Font:"

------------------------------------------------------------------------
-- Custom Aliases
------------------------------------------------------------------------
raiseXMobar = "sleep 1 && xdotool windowraise `xdotool search --all --name xmobar`"

takeScreenShot = "scrot '%Y-%m-%d-%s_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir SCREENSHOTS)'"

xmonadRestart = "xmonad --restart"
