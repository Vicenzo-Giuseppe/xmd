-- Sample XMonad client from http://hackage.haskell.org/package/xmonad-contrib-0.15/docs/XMonad-Hooks-ServerMode.html

import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import System.Environment
import System.IO

main :: IO ()
main = parse True "XMONAD_COMMAND" =<< getArgs

parse :: Bool -> String -> [String] -> IO ()
parse input addr args = case args of
        ["--"] | input -> repl addr
               | otherwise -> return ()
        ("--":xs) -> sendAll addr xs
        ("-a":a:xs) -> parse input a xs
        ("-h":_) -> showHelp
        ("--help":_) -> showHelp
        ("-?":_) -> showHelp
        ("--recompile") -> recompile True >>= flip unless exitFailure

        (a@('-':_):_) -> hPutStrLn stderr ("Unknown option " ++ a)

        (x:xs) -> sendCommand addr x >> parse False addr xs
        [] | input -> repl addr
           | otherwise -> return ()

repl :: String -> IO ()
repl addr = do e <- isEOF
               case e of
                True -> return ()
                False -> do l <- getLine
                            sendCommand addr l
                            repl addr

sendAll :: String -> [String] -> IO ()
sendAll addr ss = foldr (\a b -> sendCommand addr a >> b) (return ()) ss

sendCommand :: String -> String -> IO ()
sendCommand addr s = do
  d   <- openDisplay ""
  rw  <- rootWindow d $ defaultScreen d
  a <- internAtom d addr False
  m <- internAtom d s False
  allocaXEvent $ \e -> do
                  setEventType e clientMessage
                  setClientMessageEvent e rw a 32 m currentTime
                  sendEvent d rw False structureNotifyMask e
                  sync d False

showHelp :: IO ()
showHelp = do pn <- getProgName
              putStrLn ("Send commands to a running instance of xmonad. xmonad.hs must be configured with XMonad.Hooks.ServerMode to work.\n-a atomname can be used at any point in the command line arguments to change which atom it is sending on.\nIf sent with no arguments or only -a atom arguments, it will read commands from stdin.\nEx:\n" ++ pn ++ " cmd1 cmd2\n" ++ pn ++ " -a XMONAD_COMMAND cmd1 cmd2 cmd3 -a XMONAD_PRINT hello world\n" ++ pn ++ " -a XMONAD_PRINT # will read data from stdin.\nThe atom defaults to XMONAD_COMMAND.")

recompile :: MonadIO m => Bool -> m Bool
recompile force = io $ do
    dir <- getXMonadDir
    let binn = ".cache/xmonad-x86_64-linux"
        bin  = dir </> binn
        base = dir </> "xmonad"
        err  = base ++ ".errors"
        src  = base ++ ".hs"
        lib  = dir </> "lib"
    libTs <- mapM getModTime . Prelude.filter isSource =<< allFiles lib
    srcT <- getModTime src
    binT <- getModTime bin
    if force || any (binT <) (srcT : libTs)
      then do
        -- temporarily disable SIGCHLD ignoring:
        uninstallSignalHandlers
        status <- bracket (openFile err WriteMode) hClose $ \h ->
            waitForProcess =<< runProcess "ghc" ["--make", "xmonad.hs", "-i", "-ilib", "-fforce-recomp", "-v0", "-o",binn] (Just dir)
                                    Nothing Nothing Nothing (Just h)

        -- re-enable SIGCHLD:
        installSignalHandlers

        -- now, if it fails, run xmessage to let the user know:
        when (status /= ExitSuccess) $ do
            ghcErr <- readFile err
            let msg = unlines $
                    ["Error detected while loading xmonad configuration file: " ++ src]
                    ++ lines (if null ghcErr then show status else ghcErr)
                    ++ ["","Please check the file for errors."]
            -- nb, the ordering of printing, then forking, is crucial due to
            -- lazy evaluation
            hPutStrLn stderr msg
            forkProcess $ executeFile "xmessage" True ["-default", "okay", msg] Nothing
            return ()
        return (status == ExitSuccess)
      else return True
 where getModTime f = catch (Just <$> getModificationTime f) (\(SomeException _) -> return Nothing)
       isSource = flip elem [".hs",".lhs",".hsc"]
       allFiles t = do
            let prep = map (t</>) . Prelude.filter (`notElem` [".",".."])
            cs <- prep <$> catch (getDirectoryContents t) (\(SomeException _) -> return [])
            ds <- filterM doesDirectoryExist cs
            concat . ((cs \\ ds):) <$> mapM allFiles ds



-- | Return the path to @~\/.xmonad@.
getXMonadDir :: MonadIO m => m String
getXMonadDir = io $ getAppUserDataDirectory "xmd"
