import Data.Time
import System.Locale (defaultTimeLocale)
import Data.Maybe (fromJust)
import Data.List (intercalate)
import Text.Printf

plusOneTime :: UTCTime -> ZonedTime
plusOneTime t = utcToZonedTime (hoursToTimeZone 1) t

fmtTime t =
  formatTime defaultTimeLocale "%Y-%m-%d %H:%M %z" t

intToDouble :: Int -> Double
intToDouble = fromRational . toRational

picosToDouble = fromRational . toRational

timeParsed :: String -> UTCTime
timeParsed line =
  fromJust t
  where
    t = parseTime defaultTimeLocale "%Y-%m-%d %H:%M" line

getddays t1 t2 = diffDays (lod t1) (lod t2)
  where
    lod = (localDay . zonedTimeToLocalTime)

getYear t = year
  where
  (year, month, day) = toGregorian (localDay (zonedTimeToLocalTime t))

inBeats :: ZonedTime -> Double
inBeats t = ((intToDouble s) + sd) / 86.4
  where
    sd = picosToDouble seconds
    s = ((minutes * 60) + (hours * 3600))
    TimeOfDay hours minutes seconds =  t1
    t1 = localTimeOfDay (zonedTimeToLocalTime t)

--showBeats beats = digitsF "%07.3f" beats 3
showBeats051 beats = digitsF "%05.1f" beats 1
showBeatsBMT = (++ " BMT") . showBeats051

trunk :: Double -> Int -> Double
trunk x n = (fromIntegral (floor (x * t))) / t
  where t = 10^n

digitsF :: String -> Double -> Int -> String
digitsF fmt x n = printf fmt (trunk x n)

wss = map timeParsed solsticesUtcList
wss1 = map plusOneTime wss
dds t1 = map (\t2 -> (t2, getddays t1 t2)) wss1

showDay = printf "%03d"
showBeats = showBeatsBMT . inBeats

utcToSolstician ut 
  | null ts   = "Not implemented for days before " ++ (head solsticesUtcList)
  | otherwise = intercalate "." [show year, showDay day, showBeats t1]
  where
    t1 = plusOneTime ut 
    ts = takeWhile (\(t2,d) -> d >= 1) (dds t1)
    (t,day) = last (takeWhile (\(t2,d) -> d >= 1) (dds t1))
    year = getYear t + 1

main = do
  now <- getCurrentTime
  (putStrLn . utcToSolstician) now

solsticesUtcList = [
  "2015-12-22 04:48",
  "2016-12-21 10:44",
  "2017-12-21 16:28",
  "2018-12-21 22:22",
  "2019-12-22 04:19",
  "2020-12-21 10:02",
  "2021-12-21 15:59",
  "2022-12-21 21:47",
  "2023-12-22 03:27",
  "2024-12-21 09:20",
  "2025-12-21 15:02",
  "2026-12-21 20:49",
  "2027-12-22 02:41",
  "2028-12-21 08:19",
  "2029-12-21 14:14",
  "2030-12-21 20:09",
  "2031-12-22 01:55",
  "2032-12-21 07:55",
  "2033-12-21 13:45",
  "2034-12-21 19:33",
  "2035-12-22 01:30",
  "2036-12-21 07:12",
  "2037-12-21 13:07",
  "2038-12-21 19:01",
  "2039-12-22 00:40",
  "2040-12-21 06:32",
  "2041-12-21 12:17",
  "2042-12-21 18:03",
  "2043-12-22 00:01",
  "2044-12-21 05:43",
  "2045-12-21 11:34",
  "2046-12-21 17:27",
  "2047-12-21 23:07",
  "2048-12-21 05:01",
  "2049-12-21 10:51",
  "2050-12-21 16:37",
  "2051-12-21 22:33",
  "2052-12-21 04:16",
  "2053-12-21 10:09",
  "2054-12-21 16:09",
  "2055-12-21 21:55",
  "2056-12-21 03:50",
  "2057-12-21 09:42",
  "2058-12-21 15:24",
  "2059-12-21 21:17",
  "2060-12-21 03:00",
  "2061-12-21 08:48",
  "2062-12-21 14:42",
  "2063-12-21 20:20",
  "2064-12-21 02:08",
  "2065-12-21 07:59",
  "2066-12-21 13:45",
  "2067-12-21 19:43",
  "2068-12-21 01:32",
  "2069-12-21 07:21",
  "2070-12-21 13:19",
  "2071-12-21 19:03",
  "2072-12-21 00:55",
  "2073-12-21 06:50",
  "2074-12-21 12:35",
  "2075-12-21 18:26",
  "2076-12-21 00:13",
  "2077-12-21 06:00",
  "2078-12-21 11:57",
  "2079-12-21 17:43",
  "2080-12-20 23:32",
  "2081-12-21 05:22",
  "2082-12-21 11:04",
  "2083-12-21 16:52",
  "2084-12-20 22:41",
  "2085-12-21 04:28",
  "2086-12-21 10:22",
  "2087-12-21 16:08",
  "2088-12-20 21:56",
  "2089-12-21 03:52",
  "2090-12-21 09:43",
  "2091-12-21 15:38",
  "2092-12-20 21:31",
  "2093-12-21 03:20",
  "2094-12-21 09:13",
  "2095-12-21 15:00",
  "2096-12-20 20:46",
  "2097-12-21 02:36",
  "2098-12-21 08:20",
  "2099-12-21 14:04",
  "2100-12-21 19:50",
  "2101-12-22 01:38",
  "2102-12-22 07:32",
  "2103-12-22 13:24",
  "2104-12-21 19:12",
  "2105-12-22 01:03",
  "2106-12-22 06:53",
  "2107-12-22 12:42",
  "2108-12-21 18:34",
  "2109-12-22 00:27",
  "2110-12-22 06:18",
  "2111-12-22 12:07",
  "2112-12-21 17:55",
  "2113-12-21 23:46",
  "2114-12-22 05:39",
  "2115-12-22 11:27" ]
 

