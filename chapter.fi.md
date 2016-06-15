# Talvipäivänseisauksen ajanlasku

+ Talvipäivänseisauksen ajanlaskussa vuosi alkaa talvipäivänseisauksesta. 
+ Päivät numeroidaan 0..366.
+ Kellonaika ilmoitetaan desimaaliaikana 000..999.
+ Aikavyöhyke on BMT eli Swatch Internet Timen käyttämä Biel Meantime. 
+ Vuorokausi vaihtuu Keski-Euroopan normaaliaikavyöhykkeen UTC+1 mukaisesti. 
+ Vuoden ensimmäinen vuorokausi, numero 1, alkaa talvipäivänseisauksen jälkeisenä keskiyönä kyseisen aikavyöhykkeen mukaisesti. 

## Kellonaika nyt

Nykyhetken päivämäärän ja kellonajan saamme kirjaston `Data.Time` funktiolla `getCurrentTime`. Se kertoo kellonajan aikavyöhykkeellä UTC+0. 

Kirjaston `System.Locale` funktio `defaultTimeLocale` toimii funktion `formatTime` parametrina, kertoen funktiolle kellonajan muotoiluun liittyvät oletusasetukset. Tässä esimerkissä niillä ei ole merkitystä. 

```haskell
import Data.Time
import System.Locale (defaultTimeLocale)

main = do
  now <- getCurrentTime
  putStrLn (formatTime defaultTimeLocale "%Y-%m-%d %H:%M" now)
```

## Kellonaika aikavyöhykkeellä UTC+1

Määrittelemme funktion `plusOneTime`, joka palauttaa parametrina annetun kellonajan aikavyöhykkeen `+0100` aikana.

```haskell
plusOneTime :: UTCTime -> ZonedTime
plusOneTime t = utcToZonedTime (hoursToTimeZone 1) t
```

## Kellonajan muotoilu

Voimme muotoilla kellonajan funktion `formatTime` avulla

```haskell
fmtTime t =
  formatTime defaultTimeLocale "%Y-%m-%d %H:%M %z" t
```

## Funktio `getCurrentTime`

Funktion `getCurrentTime` tyyppi on `IO UTCTime`.

```haskell
> import Data.Time
> :t getCurrentTime
getCurrentTime :: IO UTCTime
```

## Esimerkkituloste

Konstruktorin `IO` vuoksi kutsumme funktiota `do`-lausekkeessa, jossa varsinainen arvo puretaan konstruktorista operaatiolla `<-`.

```haskell
> now <- getCurrentTime
> putStrLn (formatTime defaultTimeLocale "%Y-%m-%d %H:%M" now)
2016-06-14 13:23
> putStrLn (fmtTime now)
2016-06-14 13:23 +0000
> let t1 = plusOneTime now
> putStrLn (fmtTime t1)
2016-06-14 14:23 +0100
```

## Funktio `getZonedTime`

Funktio `getZonedTime` palauttaa paikallisen ajan aikavyöhykkeineen. Sen tyyppi on `IO ZonedTime`.

```haskell
> :t getZonedTime
getZonedTime :: IO ZonedTime
```

Aikavyöhykkeellä UTC+2 funktio antaa seuraavan tuloksen:

```haskell
> zt <- getZonedTime
> putStrLn (fmtTime zt)
2016-06-14 15:28 +0200
```

Talvipäivänseisauksen ajanlaskussa emme kuitenkaan tätä tulosta tarvitse.

## Muunnos merkkijonosta kellonajaksi

Funktio `parseTime` jäsentää merkkijonomuotoisen kellonajan. Funktion palautusarvo on tyyppiä `Maybe t`, jossa `t` on jokin tyypillisistä kellonajan tyypeistä, tässä `UTCTime`. 

```haskell
> :t parseTime
parseTime
  :: ParseTime t =>
     System.Locale.TimeLocale -> String -> String -> Maybe t
```

Oletamme merkkijonon hyvin muodostetuksi, jolloin jäsentäminen onnistuu ja voimme käyttää kirjaston `Data.Maybe` funktiota `fromJust` purkamaan palautusarvo konstruktorista `Just`.

```haskell
timeParsed :: String -> UTCTime
timeParsed line =
  fromJust t where
    t = parseTime defaultTimeLocale "%Y-%m-%d %H:%M" line
```

## Muunnos tietotyypistä `UTCTime` tietotyypiksi `LocalTime`

Muistamme, että funktion `plusOneTime` parametri on tyyppiä `UTCTime` ja palautusarvo tyyppiä `ZonedTime`.

```haskell
> :t plusOneTime
plusOneTime :: UTCTime -> ZonedTime
```

Funktion `zonedTimeToLocalTime` avulla muunnamme tyyppiä `ZonedTime` olevan kellonajan tyyppiä `LocalTime` olevaksi kellonajaksi.

```haskell
> :t zonedTimeToLocalTime
zonedTimeToLocalTime :: ZonedTime -> LocalTime
```

Nyt saamme

```haskell
> timeParsed "2015-12-31 22:59"
2015-12-31 22:59:00 UTC
> (plusOneTime . timeParsed) "2015-12-31 22:59"
2015-12-31 23:59:00 +0100
> (zonedTimeToLocalTime . plusOneTime . timeParsed) "2015-12-31 22:59"
2015-12-31 23:59:00
> (localDay . zonedTimeToLocalTime . plusOneTime . timeParsed) "2015-12-31 22:59"
2015-12-31

```

## Kahden päivämäärän välinen ero

Tietotyypillä `LocalTime` on funktio `localDay`, joka palauttaa päivämäärän tyyppiä `Day`. 

```haskell
> :t localDay
localDay :: LocalTime -> Day
> (localDay . zonedTimeToLocalTime . plusOneTime . timeParsed) "2015-12-31 22:59"
2015-12-31
```

Tietotyypillä `Day` on funktio `diffDays`, joka palauttaa annetun kahden päivämäärän eron kokonaislukuna.

```haskell
> :t diffDays
diffDays :: Day -> Day -> Integer
```

Määrittelemme funktion `getddays`, joka suorittaa muunnokset tyypistä `ZonedTime` ja palauttaa kahden päivämäärän välisen eron.

```haskell
getddays :: ZonedTime -> ZonedTime -> Integer
getddays t1 t2 = diffDays d2 d1
  where
    d1 = localDay (zonedTimeToLocalTime t1)
    d2 = localDay (zonedTimeToLocalTime t2)
```

Kokeilemme funktiota listan `testTimes` merkkijonoille.

```haskell
testTimes = [
  "2015-12-01 22:59",
  "2015-12-31 22:59",
  "2015-12-31 23:01", 
  "2016-01-01 00:01" ]
```

Ensin kuitenkin määrittelemme funktion `pairs`.

```haskell
pairs xs = zip xs (tail xs)
```

Muodostamme funktion avulla listan alkioista pareja.

```haskell
> :t pairs
pairs :: [b] -> [(b, b)]
> pairs [1..5]
[(1,2),(2,3),(3,4),(4,5)]
```

Voimme nyt jäsentää merkkijonot kellonajoiksi, siirtää ne aikavyöhykkeelle `+0100`, muodostaa pareja listan peräkkäisistä alkioista ja laskea päivämäärien välisen eron.

```haskell
> map (\(a,b) -> getddays a b) (pairs (map (plusOneTime . timeParsed) testTimes))
[30,1,0]
```
Kuten odotettua, vuorokausi ei vaihdu aikavyöhykkeen `+0000` päivämäärien `"2015-12-31 23:01"` ja `"2016-01-01 00:01"` välillä aikavyöhykkeellä `+0100`, vaan tuntia aiemmin. 

## Luettelo talvipäivänseisauksista

Koska algoritmi talvipäivänseisausten laskemiseksi sisältäisi joka tapauksessa valmiita parametreja, voimme yhtä hyvin käyttää valmista luetteloa. 

```haskell
solsticesUtcList = [
  "2015-12-22 04:48",
  "2016-12-21 10:44",
  "2017-12-21 16:28",
  "2018-12-21 22:22",
  "2019-12-22 04:19",
  "2020-12-21 10:02" ]
```


```haskell
```

jatkuu...

```haskell
```


```haskell
```

```haskell
```


```haskell
```

```haskell
```

