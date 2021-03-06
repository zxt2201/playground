{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module BabyParse where

import Control.Monad.Error
import Control.Monad.State
import qualified Data.ByteString.Char8 as B
import Data.Char

data ParseError
  = NumericOverflow
  | EndOfInput
  | Chatty String
    deriving (Eq, Ord, Show)

instance Error ParseError where
  noMsg = Chatty "oh noes!"
  strMsg = Chatty

newtype Parser a = Parser {
  getParser :: ErrorT ParseError (State B.ByteString) a
} deriving (Monad, MonadError ParseError)

liftP :: State B.ByteString a -> Parser a
liftP m = Parser (lift m)

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = do
  s <- liftP get
  case B.uncons s of
    Nothing -> throwError EndOfInput
    Just (c, s)
      | p c       -> liftP (put s) >> return c
      | otherwise -> throwError (Chatty "satisfy failed :(")

optional :: Parser a -> Parser (Maybe a)
optional p = (liftM Just p) `catchError` \_ -> return Nothing

many :: Parser a -> Parser [a]
many p = do
  r <- optional p
  case r of
    Nothing -> return []
    Just a -> do 
      r <- many p
      return (a:r)

many1 p = do
  r <- p
  r2 <- many p
  return (r:r2)

letter = satisfy isLetter
digit = satisfy isDigit
optionalLetter = optional letter

optionalWord = many1 letter
word = many1 letter

integer :: Parser Integer
integer = 
  optional minus >>= \r -> case r of
    Nothing -> digits
    Just '-' -> digits >>= return . negate
  where
    minus = satisfy (== '-')
    digits = many1 digit >>= return . read

int :: Parser Int
int = do
  i <- integer
  if i >= fromIntegral (minBound::Int) && i <= fromIntegral (maxBound::Int)
    then return $ fromIntegral i
    else throwError (Chatty ("Int out of bounds: " ++ (show i)))

asdf = "asdf"
numExpr = "2.3 + 5.1"

eg1a = runState (runErrorT (getParser $ letter)) (B.pack asdf)
eg2a = runState (runErrorT (getParser $ letter)) (B.pack numExpr)
eg3a = runState (runErrorT (getParser $ optionalLetter)) (B.pack asdf)
eg4a = runState (runErrorT (getParser $ optionalLetter)) (B.pack numExpr)

execParser :: Parser a -> B.ByteString -> (Either ParseError a, B.ByteString)
execParser = runState . runErrorT . getParser

runParser :: Parser a -> B.ByteString -> Either ParseError (a, B.ByteString)
runParser p bs = case execParser p bs of
  (Left err, _) -> Left err
  (Right r, bs) -> Right (r, bs)

eg1b = runParser letter (B.pack asdf)
eg2b = runParser letter (B.pack numExpr)
eg3b = runParser optionalLetter (B.pack asdf)
eg4b = runParser optionalLetter (B.pack numExpr)

eg5 = runParser optionalWord (B.pack "one two three")
eg6 = runParser optionalWord (B.pack numExpr)

eg7 = runParser word (B.pack "one two three")
eg8 = runParser word (B.pack numExpr)

eg9 = execParser integer (B.pack "fooey")
eg10 = execParser integer (B.pack "1234")
eg10a = execParser integer (B.pack "-1234")
eg10b = execParser integer (B.pack "-")
eg10c = execParser integer (B.pack "-1")

eg11 = execParser int (B.pack "1234")
eg11a = execParser int (B.pack "-1234")
eg11b = execParser int (B.pack "-")
eg11c = execParser int (B.pack "-1")
eg12 = execParser int (B.pack "12341324")
eg13 = execParser int (B.pack "123413241234")
eg14 = execParser int (B.pack (show (maxBound :: Int)))
eg15 = execParser int (B.pack (show (fromIntegral (maxBound :: Int) + 1))) -- An Integer (+1) beyond (maxBound::Int).
eg16 = execParser int (B.pack (show ((maxBound :: Int) + 1))) -- Incidentally, (+1) here wraps to most (minBound::Int).
eg17 = execParser int (B.pack (show (minBound :: Int)))
eg18 = execParser int (B.pack (show (fromIntegral (minBound :: Int) - 1))) -- An Integer (-1) before (minBound::Int).
