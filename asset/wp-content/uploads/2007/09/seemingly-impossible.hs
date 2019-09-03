-- File "seemingly-impossible.hs",
-- automatically extracted from literate Haskell
-- file http://www.cs.bham.ac.uk/~mhe/papers/seemingly-impossible.html
--
-- Martin Escardo, September 2007
-- School of Computer Science, University of Birmingham, UK
--
-- These algorithms have been published and hence are in the
-- public domain.
--
-- If you use them, I'd like to know! mailto:m.escardo@cs.bham.ac.uk

data Bit = Zero | One
         deriving (Eq)
type Natural = Integer
type Cantor = Natural -> Bit
(#) :: Bit -> Cantor -> Cantor 
x # a = \i -> if i == 0 then x else a(i-1)
forsome, forevery :: (Cantor -> Bool) -> Bool
find :: (Cantor -> Bool) -> Cantor
find = find_i
forsome p = p(find(\a -> p a))
forevery p = not(forsome(\a -> not(p a)))
find_i :: (Cantor -> Bool) -> Cantor
find_i p = if forsome(\a -> p(Zero # a))
           then Zero # find_i(\a -> p(Zero # a))
           else One  # find_i(\a -> p(One  # a))
search :: (Cantor -> Bool) -> Maybe Cantor
search p = if forsome(\a -> p a) then Just(find(\a -> p a)) else Nothing
equal :: Eq y => (Cantor -> y) -> (Cantor -> y) -> Bool
equal f g = forevery(\a -> f a == g a)
coerce :: Bit -> Natural
coerce Zero = 0
coerce One = 1
f, g, h :: Cantor -> Integer
f a = coerce(a(7 * coerce(a 4) +  4 * (coerce(a 7)) + 4))
g a = coerce(a(coerce(a 4) + 11 * (coerce(a 7))))
h a = if a 7 == Zero
      then if a 4 == Zero then coerce(a  4) else coerce(a 11)
      else if a 4 == One  then coerce(a 15) else coerce(a  8)
modulus :: (Cantor -> Integer) -> Natural
modulus f = least(\n -> forevery(\a -> forevery(\b -> eq n a b --> (f a == f b))))
least :: (Natural -> Bool) -> Natural
least p = if p 0 then 0 else 1 + least(\n -> p(n+1))
(-->) :: Bool -> Bool -> Bool
p --> q = not p || q
eq :: Natural -> Cantor -> Cantor -> Bool
eq 0 a b = True
eq (n+1) a b = a n == b n  &&  eq n a b
proj :: Natural -> (Cantor -> Integer)
proj i = \a -> coerce(a i)
find_ii p = if p(Zero # find_ii(\a -> p(Zero # a)))
            then Zero # find_ii(\a -> p(Zero # a))
            else One  # find_ii(\a -> p(One  # a))
find_iii :: (Cantor -> Bool) -> Cantor
find_iii p = h # find_iii(\a -> p(h # a))
       where h = if p(Zero # find_iii(\a -> p(Zero # a))) then Zero else One
find_iv :: (Cantor -> Bool) -> Cantor
find_iv p = let leftbranch = Zero # find_iv(\a -> p(Zero # a))
            in if p(leftbranch)
               then leftbranch
               else One # find_iv(\a -> p(One # a))
find_v :: (Cantor -> Bool) -> Cantor
find_v p = \n ->  if q n (find_v(q n)) then Zero else One
 where q n a = p(\i -> if i < n then find_v p i else if i == n then Zero else a(i-n-1))
find_vi :: (Cantor -> Bool) -> Cantor
find_vi p = b 
 where b = \n -> if q n (find_vi(q n)) then Zero else One
       q n a = p(\i -> if i < n then b i else if i == n then Zero else a(i-n-1))
find_vii :: (Cantor -> Bool) -> Cantor
find_vii p = b 
 where b = id'(\n -> if q n (find_vii(q n)) then Zero else One)
       q n a = p(\i -> if i < n then b i else if i == n then Zero else a(i-n-1))
data T x = B x (T x) (T x)
code :: (Natural -> x) -> T x
code f = B (f 0) (code(\n -> f(2*n+1))) 
                 (code(\n -> f(2*n+2)))
decode :: T x -> (Natural -> x)
decode (B x l r) n |  n == 0    = x
                   |  odd n     = decode l ((n-1) `div` 2)
                   |  otherwise = decode r ((n-2) `div` 2)
id' :: (Natural -> x) -> (Natural -> x)
id' = decode.code
f',g',h' :: Cantor -> Integer
f' a = a'(10*a'(3^80)+100*a'(4^80)+1000*a'(5^80)) where a' i = coerce(a i)
g' a = a'(10*a'(3^80)+100*a'(4^80)+1000*a'(6^80)) where a' i = coerce(a i)
h' a = a' k 
    where i = if a'(5^80) == 0 then 0    else 1000
          j = if a'(3^80) == 1 then 10+i else i
          k = if a'(4^80) == 0 then j    else 100+j 
          a' i = coerce(a i)
pointwiseand :: [Natural] -> (Cantor -> Bool)
pointwiseand [] = \b -> True
pointwiseand (n:a) = \b -> (b n == One) && pointwiseand a b
sameelements :: [Natural] -> [Natural] -> Bool
sameelements a b = equal (pointwiseand a) (pointwiseand b)
