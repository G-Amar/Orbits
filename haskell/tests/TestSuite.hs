module Main where
    import Test.HUnit
    import qualified MyLib
    import qualified System.Exit as Exit

    main = do
         status <- runTestTT tests
         if failures status > 0 then Exit.exitFailure else return ()
-- run tests with:
--     cabal test

    solarSystem = "Sun 57909227 Mercury\n\
                    \Earth 384400 Moon\n\
                    \Sun 149598262 Earth\n\
                    \Moon 1757 LROrbiter\n\
                    \Mars 9376 Phobos\n\
                    \Mars 23458 Deimos\n\
                    \Sun 227943824 Mars\n\
                    \Sun 778340821 Jupiter\n\
                    \Sun 1426666422 Saturn\n\
                    \Sun 2870658186 Uranus\n\
                    \Sun 4498396441 Neptune\n"
-- here are some standard tests
-- you should augment them with your own tests for development purposes
    process = MyLib.process
    getlines = MyLib.getlines
    getwords = MyLib.getwords
    tests = test [
      "Line parse" ~:
          [["Sun","57909227","Mercury"],
          ["Earth","384400","Moon"],
          ["Sun","149598262","Earth"],
          ["Moon","1757","LROrbiter"],
          ["Mars","9376","Phobos"],
          ["Mars","23458","Deimos"],
          ["Sun","227943824","Mars"],
          ["Sun","778340821","Jupiter"],
          ["Sun","1426666422","Saturn"],
          ["Sun","2870658186","Uranus"],
          ["Sun","4498396441","Neptune"],
          ["Sun","Moon"],
          ["Deimos","Moon"],
          ["Deimos"],
          ["Deimos","Phobos"],
          ["Moon"],
          ["LROrbiter"]] ~=? (getwords.getlines) (solarSystem ++ "Sun Moon\n\
                    \Deimos Moon\n\
                    \Deimos\n\
                    \Deimos Phobos\n\
                    \Moon\n\
                    \LROrbiter\n"),
      "planetinfo" ~:
          "\nDeimos orbits Mars Sun\n\
          \Moon orbits Earth Sun\n\
          \LROrbiter orbits Moon Earth Sun\n\
          \Earth orbits Sun\n\
          \Phobos orbits Mars Sun\n" ~=? process (solarSystem ++ "Sun\n\
                    \Deimos\n\
                    \Moon\n\
                    \LROrbiter\n\
                    \Earth\n\
                    \Phobos\n")
      ,"Calculatedistance" ~:
          "From Phobos to Deimos is 32834km\n\
          \From Moon to Phobos is 377935862km\n\
          \From Sun to Moon is 149982662km\n\
          \From Moon to Sun is 149982662km\n\
          \From LROrbiter to Moon is 1757km\n\
          \From Moon to LROrbiter is 1757km\n\
          \From Moon to Moon is 0km\n\
          \From Sun to Sun is 0km\n" ~=? process (solarSystem ++ 
                    "Phobos Deimos\n\
                    \Moon Phobos\n\
                    \Sun Moon\n\
                    \Moon Sun\n\
                    \LROrbiter Moon\n\
                    \Moon LROrbiter\n\
                    \Moon Moon\n\
                    \Sun Sun\n")
      ,"direct distance" ~:
          "From Earth to Sun is 149598262km\n" ~=? process "Sun 149598262 Earth\nEarth Sun\n"
      ,"direct orbit" ~:
          "Earth orbits Sun\n" ~=? process "Sun 149598262 Earth\nEarth\n"
      ,"solar system1" ~:
          "From Sun to Moon is 149982662km\n\
          \From Deimos to Moon is 377949944km\n\
          \Deimos orbits Mars Sun\n\
          \From Deimos to Phobos is 32834km\n\
          \Moon orbits Earth Sun\n\
          \LROrbiter orbits Moon Earth Sun\n" ~=? process (solarSystem ++ "Sun Moon\n\
                    \Deimos Moon\n\
                    \Deimos\n\
                    \Deimos Phobos\n\
                    \Moon\n\
                    \LROrbiter\n")
      ,"solar system2" ~:
          "From LROrbiter to Deimos is 377951701km\n" ~=? process (solarSystem ++ "LROrbiter Deimos\n")
      ,"Longer example" ~:
          "From Phobos to Deimos is 32834km\n\
          \From Moon to Phobos is 377935862km\n\
          \From Sun to Moon is 149982662km\n\
          \From Moon to Sun is 149982662km\n\
          \From LROrbiter to Moon is 1757km\n\
          \From Moon to LROrbiter is 1757km\n\
          \From Moon to Moon is 0km\n\
          \From Sun to Sun is 0km\n\
          \Moon orbits Earth Sun\n\
          \\n\
          \Mercury orbits Sun\n\
          \LROrbiter orbits Moon Earth Sun\n\
          \Neptune orbits Sun\n" ~=? process (solarSystem ++ 
                    "Phobos Deimos\n\
                    \Moon Phobos\n\
                    \Sun Moon\n\
                    \Moon Sun\n\
                    \LROrbiter Moon\n\
                    \Moon LROrbiter\n\
                    \Moon Moon\n\
                    \Sun Sun\n\
                    \Moon\n\
                    \Sun\n\
                    \Mercury\n\
                    \LROrbiter\n\
                    \Neptune\n")
      ]