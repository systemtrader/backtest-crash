module OptPort where 
import Database.HDBC 
import Database.HDBC.Sqlite3
import Portfolio
import Dates 
import Data.Time 
import Data.List 
import Lib
import SqlInterface

toSecurity::[SqlValue] -> Security
toSecurity xs@[_, _,_] = toSecurity (xs++[SqlDouble 0.0]) 
toSecurity xs@[SqlByteString s, SqlByteString d, SqlDouble p, SqlDouble st] 
    | length xs /= 4 = error "Wrong number of input given\n"
    | otherwise = Equity (filter (/= '\"') (show s)) (realToFrac p) dt (realToFrac st) where
    dt = parseTimeOrError True defaultTimeLocale "\"%Y%m%d\"" (show d) :: UTCTime

toPort :: Double -> [Security] -> Portfolio
toPort totWealth xs = 
    let 
        alloc = totWealth / fromIntegral (length (xs))
        f x = floor (alloc /price x)
<<<<<<< HEAD
        tport = Portfolio {records = (zip xs (map f xs)),  cash = Cash "Dollars" 0.0}  
        tval = portValue tport
        dcash = Cash "Dollars" (totWealth - tval)
    in (\(Portfolio sx _) zcash -> Portfolio sx zcash) tport dcash
=======
        tport = Portfolio (zipWith (\a b -> (a, b)) xs (map f xs))  
        tval = portValue tport
    in (\(Portfolio sx) -> Portfolio (sx ++ [(Cash {symbol = "Dollars", price = (totWealth - tval)}, 1)])) tport
>>>>>>> e2bb0da6eef2215aa4f58b8e8b04e0f74a2b18d4

secValue :: Security -> Shares -> Double
secValue asset shares = 
    (price asset)*(fromIntegral shares)

portValue :: Portfolio -> Double
<<<<<<< HEAD
portValue (Portfolio xs c) = 
    (amount c) + sum [secValue asset share| (asset, share) <- xs]
=======
portValue (Portfolio xs) = 
    sum [secValue asset share| (asset, share) <- xs]
>>>>>>> e2bb0da6eef2215aa4f58b8e8b04e0f74a2b18d4

wealthSeries :: Double -> [[Security]] ->  [[Security]] -> [(Portfolio, Portfolio)]
-- Return porfolio prices are the start and end of the investment period
-- the old portfolio is the fist in the pair.
wealthSeries _ _ [] = []
wealthSeries value (x:xs) (y:ys) = (xport, yport) : wealthSeries (portValue yport) xs ys where
        -- The point of recomputing the portfolio is to figure out the
        -- shares. This makes no sense what so ever. The information about
        -- shares really out to be passed down.
        xport = toPort value x
        -- The (security, share) data is stored in ds
<<<<<<< HEAD
        shares = map snd (records xport)
        -- y has its own securities. It just needs the relevant shares
        -- information. The last item corresponds to cash. The cash
        -- information is presumably not coded in the y's.
        yport = Portfolio (zip y shares) (cash xport)


buildCallBackSql :: Integer -> String
buildCallBackSql nassets = "select symbol, date, price from return \
        \ where symbol in (" ++ marks ++ ") and date = ?;" where
    marks = intersperse ',' $ replicate (fromInteger nassets) '?' 
=======
        ds = (\(Portfolio s) -> s) xport
        -- y has its own securities. It just needs the relevant shares
        -- information. The last item corresponds to cash. The cash
        -- information is presumably not coded in the y's.
        yport = Portfolio ((zipWith (\a b -> (a,b)) y [s| (_, s) <- init ds]) ++ [last ds])


buildCallBackSql :: Integer -> String
buildCallBackSql nassets = "select symbol, date, price from miniprice \
        \ where symbol in (" ++ marks ++ ") and date = ?;" where
    marks = intersperse ',' $ take (fromInteger nassets) (repeat '?') 
>>>>>>> e2bb0da6eef2215aa4f58b8e8b04e0f74a2b18d4

getEndPrice :: Connection -> [Security] -> Day  -> IO [[SqlValue]] 
getEndPrice conn secs date = quickQuery' conn (buildCallBackSql (fromIntegral (length secs))) pars where
    pars = [toSql (symbol sec) | sec <- secs] ++ [toSql dt]
    dt = filter (/= '-') (showGregorian date)  

optPort :: Connection -> Integer -> Pair Day Day  -> IO [[SqlValue]] 
optPort conn n (Pair (sd, ed)) = quickQuery' conn sqlStr [toSql sds, toSql eds, toSql n] where
    sds = filter (/= '-') (showGregorian sd)  
    eds = filter (/= '-') (showGregorian ed)  

