module Preferences where
import XMonad
windowsKey = mod4Mask
------------------------------------------------------------------------
-- Aliases
------------------------------------------------------------------------
myWorkspaces =["1:web","2:terminal","3:","4:media","5:download","6:game","7:","8:","9:","0:"] 
myWorkspaceSwitchKeys = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]
myTerminal = "alacritty"
my2ndTerminal = "konsole"
myFirefox = "firefox"
my2ndBrowser = "brave"
myTorrent = "qbittorrent"
myPhotoEditor = "darktable"
myVM = "vmware"
myEmail = "mailspring"
myFont = "xft:mononoki Nerd Font:"
------------------------------------------------------------------------
-- withWindowRules
------------------------------------------------------------------------
myFileManager = "dolphin"
myWhatsapp = "whatstux"
myImageViewer = "gwenview"
myAudioManager = "mpv"
myDiscord = "discord"
myAPIClient = "insomnia"
myTelegram = "telegram-desktop"
myVimBrowser= "vieb"
mySpotify = ""
------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------
raiseXMobar = "sleep 0.5 && xdotool windowraise `xdotool search --all --name xmobar`"
takeScreenShot = "scrot '%Y-%m-%d-%s_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir SCREENSHOTS)'"
xmonadRestart = "xmonad --restart"
