import Data.Time
import System.Locale (defaultTimeLocale)
import Data.Maybe

plusOneTime :: UTCTime -> ZonedTime
plusOneTime t = utcToZonedTime (hoursToTimeZone 1) t

fmtTime t =
  formatTime defaultTimeLocale "%Y-%m-%d %H:%M %z" t

timeParsed :: String -> UTCTime
timeParsed line =
  fromJust t where
    t = parseTime defaultTimeLocale "%Y-%m-%d %H:%M" line

getddays :: ZonedTime -> ZonedTime -> Integer
getddays t1 t2 = diffDays d2 d1
  where
    d1 = localDay (zonedTimeToLocalTime t1)
    d2 = localDay (zonedTimeToLocalTime t2)

pairs xs = zip xs (tail xs)

main = do
  let
    strs = testTimes
    utimes = map timeParsed strs
    times = map plusOneTime utimes
    days = map (\(a,b) -> getddays a b) (pairs times)
  print days

testTimes = [
  "2015-12-01 22:59",
  "2015-12-31 22:59",
  "2015-12-31 23:01", 
  "2016-01-01 00:01" ]

