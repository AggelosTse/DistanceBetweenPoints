import numbers
import time

import 3D
import --
import a
import alias
import and
import apply
import arguments
import based
import calculations
import catch
import command
import Control.Exception
import Data.List
import Data.Maybe
import Data.Time
import Define
import diffUTCTime
import exceptions
import file
import filter
import for
import function
import functions
import getArgs
import getCurrentTime
import handle
import hGetContents
import import
import Importing
import into
import IOException
import IOMode
import key
import line
import list
import lists
import mapMaybe
import Nothing
import on
import openFile
import operations
import out
import parse
import point
import readMaybe
import ReadMode
import results
import safely
import sort
import sortOn
import strings
import System.Environment
import System.IO
import Text.Read
import to
import type
type Point = (Double, Double, Double)

-- Function to read points from a file
readFilePoints :: FilePath -> IO (Maybe [Point])
readFilePoints fileName = catch (do
    handle <- openFile fileName ReadMode  -- Open the file in read mode
    contents <- hGetContents handle  -- Read the entire contents of the file
    return $ Just $ mapMaybe parseLine (lines contents)  -- Parse each line into a Point, ignoring malformed lines
    ) handleError
  where
    -- Function to parse a line into a Point
    parseLine :: String -> Maybe Point
    parseLine line = case words line of  -- Split the line into words
        [xStr, yStr, zStr] -> do  -- If there are exactly three words
            x <- readMaybe xStr  -- Try to parse the first word as a Double
            y <- readMaybe yStr  -- Try to parse the second word as a Double
            z <- readMaybe zStr  -- Try to parse the third word as a Double
            return (x, y, z)  -- Return the parsed Point
        _ -> Nothing  -- If the line does not have exactly three words, return Nothing

    -- Function to handle file read errors
    handleError :: IOException -> IO (Maybe [Point])
    handleError _ = do
        putStrLn "File not found."  -- Print an error message if the file is not found
        return Nothing  -- Return Nothing to indicate failure

-- Function to calculate distances from the origin for a list of points
calculateDistances :: [Point] -> [(Point, Double)]
calculateDistances points = [(point, distance point) | point <- points]
  where
    -- Function to calculate the Euclidean distance from the origin
    distance :: Point -> Double
    distance (x, y, z) = sqrt (x^2 + y^2 + z^2)

-- Function to sort points by their distances
sortPointsByDistance :: [(Point, Double)] -> [Point]
sortPointsByDistance = map fst . sortOn snd  -- Sort the list by distance and return the points

-- Main function to execute the program
main :: IO ()
main = do
    args <- getArgs  -- Get command line arguments
    if length args /= 1
        then putStrLn "Usage: runhaskell script.hs <file_name>"  -- Print usage message if the number of arguments is incorrect
        else do
            let fileName = head args  -- Get the file name from the arguments
            startTime <- getCurrentTime  -- Record the start time
            maybePoints <- readFilePoints fileName  -- Read points from the file

            case maybePoints of
                Nothing -> return ()  -- Do nothing if reading points failed
                Just points -> do
                    let distances = calculateDistances points  -- Calculate distances from the origin
                    let sortedPoints = sortPointsByDistance distances  -- Sort points by their distances
                    putStrLn "Sorted Points:"  -- Print a header
                    mapM_ print sortedPoints  -- Print each sorted point
                    endTime <- getCurrentTime  -- Record the end time
                    putStrLn $ "Compilation time: " ++ show (diffUTCTime endTime startTime)  -- Print the time taken
