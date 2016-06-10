# Talvipäivänseisauksen ajanlasku

+ Talvipäivänseisauksen ajanlaskussa vuosi alkaa talvipäivänseisauksesta. 
+ Päivät numeroidaan 0..366.
+ Kellonaika ilmoitetaan desimaaliaikana 000..999.
+ Aikavyöhyke on BMT eli Swatch Internet Timen käyttämä Biel Meantime. 
+ Vuorokausi vaihtuu Keski-Euroopan normaaliaikavyöhykkeen UTC+1 mukaisesti. 
+ Vuoden ensimmäinen vuorokausi, numero 1, alkaa talvipäivänseisauksen jälkeisenä keskiyönä kyseisen aikavyöhykkeen mukaisesti. 

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
plusOneTime t = 
  ztime t
  where
    tz = hoursToTimeZone 1 -- create a +0100 timezone
    ztime t = utcToZonedTime tz t
```

## Kellonajan muotoilu

Voimme muotoilla kellonajan funktion `formatTime` avulla

```haskell
fmtTime t =
  formatTime defaultTimeLocale "%Y-%m-%d %H:%M %z" t
```

## Funktiot `getCurrentTime` ja `getZonedTime`

Funktion `getCurrentTime` tyyppi on `IO UTCTime`.

```haskell
> import Data.Time
> :t getCurrentTime
getCurrentTime :: IO UTCTime
```

Konstruktorin `IO` vuoksi kutsumme funktiota `do`-lausekkeessa, jossa varsinainen arvo puretaan konstruktorista operaatiolla `<-`.

Funktio `getZonedTime` palauttaa paikallisen ajan aikavyöhykkeineen. Sen tyyppi on `IO ZonedTime`.

```haskell
> :t getZonedTime
getZonedTime :: IO ZonedTime
```

Pääohjelma esimerkkeineen näyttää nyt seuraavalta:

```haskell
main = do
  now <- getCurrentTime
  putStrLn (formatTime defaultTimeLocale "%Y-%m-%d %H:%M" now)
  -- 2016-06-10 11:33
  putStrLn (fmtTime now)
  -- 2016-06-10 11:33 +0000
  let t1 = plusOneTime now
  putStrLn (fmtTime t1)
  -- 2016-06-10 12:33 +0100
  zt <- getZonedTime
  putStrLn (fmtTime zt)
  -- 2016-06-10 13:33 +0200
```



```haskell
```



```haskell
```


