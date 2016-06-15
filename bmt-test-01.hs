import Data.Time
import System.Locale (defaultTimeLocale)
import Data.Maybe

plusOneTime :: UTCTime -> ZonedTime
plusOneTime t = utcToZonedTime (hoursToTimeZone 1) t

fmtTime t =
  formatTime defaultTimeLocale "%Y-%m-%d %H:%M %z" t

advanced :: UTCTime -> [UTCTime]
advanced t = [addUTCTime x t | x <- [0,1800..48*1800]]

getddays t1 t2 = diffDays (localDay (zonedTimeToLocalTime t2))
  (localDay (zonedTimeToLocalTime t1))

adv t1 = map (\t -> (getddays (head t1) t,t)) t1

main = do
  now <- getCurrentTime
  let bs = advanced now
  let t1 = map plusOneTime bs
  putStrLn (fmtTime now)
  mapM_ (putStrLn . show) (adv t1)


