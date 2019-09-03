----------------------------------------------------------------------
-- Isomorphism between the functionals (Nat -> Bool) -> Bool and Nat.
-- See http://math.andrej.com/2009/10/12/constructive-gem-double-exponentials/

----------------------------------------------------------------------
-- Auxiliary types

type Nat = Int

type Natural = Integer

type Cantor = Nat -> Bool

type Functional = Cantor -> Bool

----------------------------------------------------------------------
-- Pairing and unpairing of natural numbers

-- encode a pair of numbers by interleaving their bits
pair :: Natural -> Natural -> Natural
pair 0 0 = 0
pair m n = let (mq, mr) = divMod m 2
               (nq, nr) = divMod n 2
           in mr + 2 * nr + 4 * pair mq nq

-- decode a pair of numbers
unpair :: Natural -> (Natural, Natural)
unpair 0 = (0, 0)
unpair n = let (p,xr) = divMod n 2
               (q,yr) = divMod p 2
               (x,y) = unpair q
           in (xr + 2*x, yr + 2*y)
           
----------------------------------------------------------------------
-- Datatypes for representing functionals


-- representation of non-constant functionals
data UCF' = Head Bool
          | And Bool UCF'
          | Or Bool UCF'
          | Decompose UCF' UCF'
            deriving (Eq, Show)

-- enumeration of all elments of UCF' without repetitions
enum' :: Natural -> UCF'
enum' 0 = Head False
enum' 1 = Head True
enum' (n+2) = case n `mod` 5 of
                 0 -> And False (enum' (n `div` 5))
                 1 -> And True (enum' (n `div` 5))
                 2 -> Or False (enum' (n `div` 5))
                 3 -> Or True (enum' (n `div` 5))
                 4 -> Decompose (enum' n0) (enum' n1) where (n0, n1) = unpair (n `div` 5)

-- the inverse of enum' computes the index of a given representation
denum' :: UCF' -> Natural
denum' (Head False) = 0
denum' (Head True) = 1
denum' (And False x) = 2 + 5 * denum' x
denum' (And True x) = 3 + 5 * denum' x
denum' (Or False x) = 4 + 5 * denum' x
denum' (Or True x) = 5 + 5 * denum' x
denum' (Decompose x y) = 6 + 5 * pair (denum' x) (denum' y)

-- convert a representation to the functional
fn' :: UCF' -> Functional
fn' f alpha = compute 0 f
    where compute k (Head b) = (alpha k == b)
          compute k (And b x) = (alpha k == b) && (compute (k+1) x)
          compute k (Or b x) = (alpha k == b) || (compute (k+1) x)
          compute k (Decompose x y) = (alpha k == False && compute (k+1) x) ||
                                      (alpha k == True && compute (k+1) y)

-- representation of arbitrary functionals
data UCF = Const Bool
         | Nonconst UCF'
           deriving (Eq, Show)

-- enumeration of all elements of UCF without repetitions
enum :: Natural -> UCF
enum 0 = Const False
enum 1 = Const True
enum (n+2) = Nonconst (enum' n)

-- the inverse of enum computes the index of a given representation
denum :: UCF -> Natural
denum (Const False) = 0
denum (Const True) = 1
denum (Nonconst x) = 2 + denum' x

-- convert a representation to the functional
fn :: UCF -> Functional
fn (Const b) = const b
fn (Nonconst x) = fn' x

-- in order to define the inverse of fn we need an auxiliary function shift

prepend :: Bool -> (Nat -> Bool) -> (Nat -> Bool)
prepend b alpha 0 = b
prepend b alpha (n+1) = alpha n

shift :: Bool -> (Functional) -> Functional
shift b f = f . (prepend b)

-- Martin Escardo's find, forevery and forsome functionals

find :: Functional -> Cantor
find p = branch x l r
    where branch x l r n |  n == 0    = x
                         |  odd n     = l ((n-1) `div` 2)
                         |  otherwise = r ((n-2) `div` 2)
          x = forsome (\l -> forsome (\r -> p (branch True l r)))
          l = find (\l -> forsome (\r -> p(branch x l r)))
          r = find (\r -> p (branch x l r))

forevery, forsome :: Functional -> Bool
forsome f = f (find f)
forevery f = not (forsome (not . f))

-- get_const f returns Just b if f is constantly b, and Nothing otherwise
get_const :: (Functional) -> Maybe Bool
get_const f =
    let b = f (const False) in
    if forevery (\alpha -> f alpha == b) then Just b else Nothing

-- the inverse of fn' computes the representation of a non-constant functional
unfn' :: Functional -> UCF'

unfn' f = case (get_const (shift False f), get_const (shift True f)) of
            (Just True, Just False) -> Head False
            (Just False, Just True) -> Head True
            (Just False, Nothing) -> And True (unfn' (shift True f))
            (Nothing, Just False) -> And False (unfn' (shift False f))
            (Just True, Nothing) -> Or False (unfn' (shift True f))
            (Nothing, Just True) -> Or True (unfn' (shift False f)) 
            (Nothing, Nothing) -> Decompose (unfn' (shift False f)) (unfn' (shift True f))

-- finally, the inverse of fn computes the representation of a functional    
unfn :: Functional -> UCF
unfn f = case get_const f of
           Just b -> Const b
           Nothing -> Nonconst (unfn' f)
