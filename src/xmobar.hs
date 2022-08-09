import Xmobar hiding (date)
------------------------------------------------------------------------
-- Colors
------------------------------------------------------------------------
background = "#212733"
------------------------------------------------------------------------
-- Custom Interfaces
------------------------------------------------------------------------
cryptoPrice pair = "curl 'https://api.coinbase.com/v2/prices/"++pair++"/spot?currency=USD' -s | jq '.data.amount' -r | sed 's/...$//'"
gpu' cmd sym = "echo $(radeontop --ticks 30 --limit 1 --dump-interval 1 --dump - | "++cmd++" )"++sym++""
btc = Run $ Com "/bin/sh"
  ["-c", cryptoPrice "BTC-USD"] "btc" 20
sysupdate = Run $ Com "/bin/sh"
  ["-c", "checkupdates | wc -l"] "sysupdate" 20
gpuavg = Run $ Com "/bin/sh"
  ["-c", gpu' "grep -oP \"gpu\\s+\\K\\w+\"" "%" ] "gpuavg" 20
gputemp = Run $ Com "/bin/sh" ["-c", "echo $(sensors | grep edge: | awk '{print $2}' | tr -d '+.' | sed 's/...$//')"] "gputemp" 20
gpuclock = Run $ Com "/bin/sh"
  ["-c", gpu' "cut -d \",\" -f16 | tr -d \".ghz\"| grep -oP \"%\\s+\\K\\w+\" | sed 's/.$//' | sed ':a;s/\\B[0-9]\\{2\\}\\>/.&/;ta'" "Ghz"] "gpuclock" 20
gpumem = Run $ Com "/bin/sh"
  ["-c", gpu' "cut -d \",\" -f13 | grep -oP \"%\\s+\\K\\w+\" | sed -r \":r;s/\\b[0-9]{1,3}\\b/0&/g;tr\" | sed ':a;s/\\B[0-9]\\{3\\}\\>/.&/;ta' |  sed 's/.$//'" "Gb"] "gpumem" 20
gpumemclock = Run $ Com "/bin/sh"
  ["-c", gpu' "cut -d ',' -f15 | cut -d ' ' -f4 | tr -d 'ghz' | sed 's/.$//'" "Ghz"] "gpumemclock" 20
------------------------------------------------------------------------
-- Default Interfaces
------------------------------------------------------------------------
cpuclock = Run $ CpuFreq
  ["-t", "<avg>GHz", "-d", "2" ] 50
memory = Run $ Memory
  ["-t", "<fn=2>\62776</fn> <usedratio>% <used>GB",
  "-d", "1","--" , "--scale", "1024"] 20
cpu = Run $ MultiCpu
  ["-t", "<fn=2>\62171</fn>  <total>",
   "-S", "True"] 20
multicoretemp = Run $ MultiCoreTemp
  ["-t", "<avg>°C" ] 20
disku = Run $ DiskU
  [("/", "<fn=2>\62003</fn> SSD: <free>")] [] 60
date = Run $ Date "<fc=#bae67e><fn=5>\61555</fn> %a, %d  %b</fc><fc=#212733>| </fc><fc=#f27983><fn=5>\61463</fn> %H:%M</fc> " "date" 50
volume = Run $ Alsa "default" "Master" ["-t", " <volume>%", "--", "-O", "", "-o", "\63145", "-h", "\61480", "-m", "\61479", "-l", "\61478", "-L", "12", "-C", "#fab387"] -- "<fn=2><status></fn>
xmonadLog = Run $ XMonadLog
------------------------------------------------------------------------
-- Commands and Template
------------------------------------------------------------------------
myCommands = [btc, memory, cpu, multicoretemp, date, disku, xmonadLog, sysupdate, volume, gputemp, gpuavg, cpuclock, gpuclock, gpumem, gpumemclock]
myTemplate :: [Char]
myTemplate =
      " <fc="++background++"> |</fc> <fc=#95e6cb><fn=2>\62815</fn></fc> \
       \<fc="++background++"> |</fc> <fc=#cad3f5><action=`alacritty -e ncdu`>%disku%</action></fc>\
       \<fc="++background++"> |</fc> <fc=#cba6f7><action=`alacritty -e htop`>%memory%</action></fc>\
       \<fc="++background++"> |</fc> <fc=#FFFFFF><action=`alacritty -e s-tui`>%multicpu% <fc=#FFFFFF>%multicoretemp%</fc> <fc=#FFFFFF>%cpufreq%</fc></action></fc>\
       \}<fc="++background++"> |</fc> <fc=#d4bfff><action=`alacritty -e yay -Syu`><fn=0>\62299</fn> %sysupdate%</action></fc>\
       \<fc="++background++">|</fc> %XMonadLog%\
       \<fc="++background++"> |</fc> <fc=#94e2d5><action=`alacritty -e radeontop -c`>RX-580<fc=#cdd6f4> %gpuavg% <fc=#FFFFFF>%gpuclock%</fc> <fc=#FFFFFF>%gpumem%</fc> <fc=#FFFFFF>%gpumemclock%</fc> </fc><fc=#FFFFFF>%gputemp%°C </fc></action></fc>\
       \{<fc="++background++"> |</fc> <fc=#f9e2af><action=`alacritty -e `>%alsa:default:Master%</action></fc>\
       \<fc="++background++">|</fc> <fc=#ffd580><action=`alacritty --hold -e curl rate.sx/btc@3M`><fn=3>\62329:</fn> %btc%</action></fc>\
       \<fc="++background++"> |</fc> %date% <fc="++background++"> | </fc>"
------------------------------------------------------------------------
-- Config
------------------------------------------------------------------------
config :: Config
config =
  defaultConfig {font = "xft:Ubuntu:weight=bold:pixelsize=20:antialias=true:hinting=true,Font Awesome 6 Free:pixelsize=22:antialias=true:hinting=true"
       , additionalFonts = [ "xft:mononoki Nerd Font:pixelsize=22:antialias=true:hinting=true"
                           , "xft:Font Awesome 6 Free Solid:pixelsize=22:antialias=true:hinting=true"
                           , "xft:Font Awesome 6 Brands:pixelsize=22:antialias=true:hinting=true"
                           ]
       , bgColor = background
       , fgColor = "#ff6c6b"
       , position = BottomSize L 100 30
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , commands = myCommands
       , alignSep = "}{"
       , template = myTemplate
       }
------------------------------------------------------------------------
-- Main 
------------------------------------------------------------------------
main :: IO ()
main = do
  xmobar config


