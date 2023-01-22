module MyLib (main, process, getlines, getwords) where

 getlines str = lines str

 getwords list = map (\line -> words line) list

 planetinfo planet planetlist = do
  --if planet has no parent, no info
  if ((getparent planet planetlist) == "") then "\n"
  else
   let chain = pathtoroot planet planetlist 
   in planet ++ " orbits" ++ (pathstring chain) ++ "\n"


 --when parent is "", will cons backwards, original planet will be at head
 pathtoroot planet planetlist 
  | planet == "" = []
  | otherwise = 
     planet:(pathtoroot (getparent planet planetlist) planetlist)
  
 --start from 2nd element as 1st is planet itself
 pathstring chain = pathstringRec (tail chain) ""
 pathstringRec [] output = output
 pathstringRec (current:rest) output = pathstringRec rest (output ++ " " ++ current)

 calcdistance planet1 planet2 planetlist = do
  let path = pathtoroot planet1 planetlist
      common = findcommon path planet2 planetlist
      dist = (distancefrom common planet1 planetlist) + (distancefrom common planet2 planetlist)
  "From " ++ planet1 ++ " to " ++ planet2 ++ " is " ++ (show dist) ++ "km\n"

 findcommon path planet planetlist 
  | (elem planet path) = planet
  | otherwise = 
     findcommon path (getparent planet planetlist) planetlist

 distancefrom parent planet planetlist 
  | (parent == planet) = 0
  | otherwise = 
     (getdistance planet planetlist) 
     + (distancefrom parent (getparent planet planetlist) planetlist)

 getdistance planet planetlist = do
  --the planet should be in the planetlist
  let val = lookup planet planetlist
  case val of
   (Just (_, d)) -> read d :: Integer
   (Nothing) -> 0
   --Nothing case must return int so default to 0

 getparent planet planetlist = do
  --the planet should be in the planetlist
  let val = lookup planet planetlist
  case val of
   (Just (parent, _)) -> parent
   (Nothing) -> ""
   --Nothing case must return string so default to "", should never reach here

 isin planet planetlist = do
  let val = lookup planet planetlist
  case val of
   (Just _) -> True
   (Nothing) -> False

 storeplanets parent d child planetlist = do
  --add child to dictionary, remove and re-add if already there
  let templist = (child, (parent, d)):(filter (\(p,_) -> p/=child) planetlist)
  if (isin parent planetlist) then
   templist
  else
  --add parent if not there, with initial parent ""
   (parent,("", "0")):templist


 --planetlist is an association list with elements of form (planet, (parent, distToParent))
 parseline words = parselineRec words "" []
 parselineRec [] output _ = output
 parselineRec (line:rest) output planetlist =
  case line of
   [parent, d, child] -> parselineRec rest output (storeplanets parent d child planetlist) 
   [planet1, planet2] -> parselineRec rest (output ++ (calcdistance planet1 planet2 planetlist)) planetlist
   [planet] -> parselineRec rest (output ++ (planetinfo planet planetlist)) planetlist
   _ -> parselineRec rest output planetlist


 main :: IO ()
 main = do
  contents <- getContents
  putStrLn $ process contents

 process :: String -> String
 process input = do 
  let lines = getlines(input)
      words = getwords(lines)
  parseline(words)

