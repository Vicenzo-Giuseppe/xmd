import Xmobar hiding (date)
------------------------------------------------------------------------
-- Custom Interfaces
------------------------------------------------------------------------
cryptoPrice :: [Char] -> [Char]
cryptoPrice pair = "curl 'https://api.coinbase.com/v2/prices/"++pair++"/spot?currency=USD' -s | jq '.data.amount' -r | sed 's/...$//'" 
btc = Run $ Com "/bin/sh" ["-c", cryptoPrice "BTC-USD"] "btc" 20
sysupdate = Run $ Com "/bin/sh" ["-c", "checkupdates | wc -l"] "sysupdate" 20
------------------------------------------------------------------------
-- Default Interfaces
------------------------------------------------------------------------
memory = Run $ Memory
   ["-t", "<fn=2>\62776</fn>  <usedratio>% <used>GB", "--" , "--scale", "1024"] 20
cpu = Run $ Cpu
   ["-t", "<fn=2>\62171</fn> <total>% ","-H","50","--high","red"] 20
multicoretemp = Run $ MultiCoreTemp
   ["-t", "<fn=2></fn><avg> °C",
    "-L", "20", "-H", "80" ] 20
date = Run $ Date "<fc=#bae67e><fn=5>\61555</fn> %a, %d  %b</fc><fc=#212733>| </fc><fc=#f27983><fn=5>\61463</fn> %H:%M</fc> " "date" 50
disku = Run $ DiskU [("/", "<fn=2>\62003</fn> SSD: <free>")] [] 60
volume = Run $ Alsa "default" "Master" ["-t", "<fn=2><status></fn> <fn=1><volume></fn>%", "--", "-O", "", "-o", "\63145", "-h", "\61480", "-m", "\61479", "-l", "\61478", "-L", "12", "-C", "#fab387"]
xmonadLog = Run $ XMonadLog
------------------------------------------------------------------------
-- Commands and Template 
------------------------------------------------------------------------
myCommands = [btc, memory, cpu, multicoretemp, date, disku, xmonadLog, sysupdate, volume]
myTemplate :: [Char]
myTemplate =
      " <fc=#212733> |</fc> <fc=#95e6cb><fn=2>\62815</fn></fc> \
       \<fc=#212733> |</fc> <fc=#cad3f5><action=`alacritty -e watch df -h`>%disku%</action></fc>\
       \<fc=#212733> |</fc> <fc=#73d0ff><action=`alacritty -e s-tui`> %cpu% %multicoretemp%</action></fc>\
       \<fc=#212733> |</fc> <fc=#ff79c6><action=`alacritty -e htop`>%memory%</action></fc>\
       \<fc=#212733> |</fc> <fc=#f9e2af><action=`alacritty -e `>%alsa:default:Master%</action></fc>\
       \}<fc=#212733>|</fc> %XMonadLog%\
       \{<fc=#212733> |</fc> <fc=#d4bfff><action=`alacritty -e yay -Syu`><fn=2>\62299</fn> %sysupdate%</action></fc>\
       \<fc=#212733>|</fc> <fc=#ffd580><action=`alacritty --hold -e curl rate.sx/btc@10d`><fn=1>\61786:%btc%</fn></action></fc>\
       \<fc=#212733> |</fc> %date% <fc=#212733> | </fc>"
------------------------------------------------------------------------
-- Config 
------------------------------------------------------------------------
config :: Config 
config =
  defaultConfig {font = "xft:Ubuntu:weight=bold:pixelsize=20:antialias=true:hinting=true,Font Awesome 6 Free Regular:pixelsize=22:antialias=true:hinting=true"
       , additionalFonts = [ "xft:mononoki Nerd Font:pixelsize=22:antialias=true:hinting=true"
                           , "xft:Font Awesome 6 Free Solid:pixelsize=22:antialias=true:hinting=true"
                           ]
       , bgColor = "#212733"
       , fgColor = "#ff6c6b"
       , position = BottomSize L 100 30
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , commands = myCommands
       , alignSep = "}{"
       , template = myTemplate
       , textOutput = False
       }
------------------------------------------------------------------------
-- Main 
------------------------------------------------------------------------
main :: IO ()
main = do
  xmobar config 


