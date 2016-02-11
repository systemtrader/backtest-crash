module Print where
import Text.PrettyPrint.Boxes
import Lib
import OptPort
<<<<<<< HEAD
import Ledger
=======
>>>>>>> e2bb0da6eef2215aa4f58b8e8b04e0f74a2b18d4
import Data.Time
import Portfolio
import Text.Printf

alignExp :: String -> String
alignExp ns = 
    let 
        fs = break (=='e')
        fi = \x -> if (length (snd x)) == 3 
                   then x else (fst x, 
                        [head (snd x)] ++"0"++(tail (snd x)))
        fc = \(x,y) -> x ++ y
    in (fc . fi . fs) ns

round' :: Integer ->  Double -> Double
round' n x = ((fromIntegral . floor) (x * t)) / t where
    t = 10^n

printResult :: Double -> [Pair Day Day] -> [Portfolio] -> Box
printResult startWealth linkedDates portfolios =
    let dh  = text "Dates"
        vh  = text "Value"
        ul  = text "-------"
        ull  = text "----------"
        std = showGregorian $ (\(Pair x) -> fst x) (linkedDates!!0)
        tlp = text . alignExp . (\x -> x::String) . printf "%.2e"
        g   = map (text . showGregorian) . uninterLink 2 
        f   = map (tlp . portValue) 
        dts = [dh, ull] ++ [text std] ++ (g linkedDates)
        pvs = [vh, ul] ++ [tlp startWealth] ++ (f portfolios)
    in  (vcat left dts) <+> 
        (emptyBox (length portfolios) 4) <+> (vcat left pvs)

printTable :: Box -> IO()
printTable box = 
    putStrLn ""
    >> printBox box
    >> putStrLn ""

printLedger :: Ledger -> IO()
printLedger ledger = 
<<<<<<< HEAD
        let theDate = showGregorian . Ledger.date $  ledger
            bf   = text . (\x -> x::String) . printf "%.0f%%" . (100*) 
            df   = text . (\x -> x::String) . printf "%.2f" 
            pf   = text . (\x -> x::String) . printf "%.2f" 
            getd x  = map df (x ledger) 
            getp :: (Ledger -> [Double]) -> [Box] 
            getp x  = map pf (x ledger) 
            gets :: (Ledger -> [Double]) -> [Box] 
            gets x  = map bf (x ledger) 
            [bs, es, bp, ep, npl] =  [gets begStats, gets endStats,  getp begPrices,  getp endPrices, getd netPnLs]
            iff = text . show
            geti x   = map iff (x ledger) 
            [esh, bsh] = map geti [endShares, begShares]
            syms = map text $ symbols ledger 
            total = totalPnL ledger
            body = vcat left syms <+> vcat right bp  <+> 
                   vcat right ep  <+> vcat right bs  <+>
                   vcat right es  <+> vcat right bsh <+>
                   vcat right esh <+> vcat right npl 
        in  putStrLn ("\n\nTrading date: " ++ theDate ++ "\n") 
            >>  printBox (body) >> putStrLn ("\nNet Gain: " ++ (printf "%.2f" total)::String)
=======
    let 
        df   = text . alignExp . (\x -> x::String) . printf "%.2e" 
        get x  = map df (x ledger) 
        [bs, es, bp, ep, npnl] = map get [begStats, endStats, begPrices, endPrices, netPnLs]





    in undefined
>>>>>>> e2bb0da6eef2215aa4f58b8e8b04e0f74a2b18d4
