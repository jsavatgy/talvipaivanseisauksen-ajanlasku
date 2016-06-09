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
solsticesUtc = [
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

