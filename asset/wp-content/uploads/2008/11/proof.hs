-- Martin Escardo, 21 Feb 2008
--
-- We write a lambda-evaluator to prove that the
-- selection monad is a monad and that the claimed
-- morphism into the continuation monad is a morphism.
--
-- Reason: the proof by hand gets rather complicated.
-- We print the "proof by hand" in the function main.
--
-- This is intended to be simple rather than efficient.

type N = Int
type Variable = (String,N)

-- Lambda terms. 
-- (Our examples are typeable, but the evaluator is untyped.)

data T = V Variable
       | L Variable T
       | A T T
     deriving (Eq)

free :: Variable -> T -> Bool
free x (V y) = x == y
free x (L y t) = x /= y && free x t
free x (A t u) = free x t || free x u

-- The following is used to manufacture fresh variables. 
-- For user-friendliness, we don't come up with new variables names.
-- We instead change the index of the variable that has to be
-- renamed. The following function helps us to do that:

order :: String -> T -> N
order a (V(b,n)) = if a == b then n else -1
order a (L(b,n) t) = max n (order a t)
order a (A t u) = max(order a t)(order a u)

-- With this we can do substitution.
-- The expression (subst x t u) substitutes t for x in u,
-- delivering the term u[x:=t].

subst :: Variable -> T -> T -> T
subst x t (V y)   = if x == y then t else V y
subst x t (L y s) | x == y    = L y s 
                  | free y t = let (a,n) = y
                                   n' = 1 + max(order a t)(order a s)
                                   y' = (a,n')
                                   s' = subst y (V y') s
                               in L y' (subst x t s')
                  | otherwise = L y (subst x t s)
subst x t (A u v) = A (subst x t u) (subst x t v)

-- We need an environment env to hold the global declarations.
-- This is to be defined in the applications of this program.
-- One is given below. 

-- We consider eta-redexes as well, but this can be disabled.
-- Only one equation needs eta (see below).

wantEtaReduction = True

hasredex :: T -> Bool
hasredex (V x) = env(V x) /= V x
hasredex (L x t) = if wantEtaReduction
                   then case t of
                          A u (V y) -> (x == y && not(free x u)) || hasredex t
                          otherwise -> hasredex t
                   else hasredex t
hasredex (A (V x) u) = env(V x) /= V x || hasredex u
hasredex (A (L x t) u) = True
hasredex (A t u) = hasredex t || hasredex u

normal :: T -> Bool
normal = not.hasredex

step :: T -> T
step (V x) = env(V x)
step (L x t) = if wantEtaReduction 
               then case t of
                      A u (V y) -> if x == y && not(free x u) then u else L x (step t)
                      otherwise -> L x (step t)
               else L x (step t)
step (A (V x) u) = if env(V x) == V x 
                   then A (V x) (step u)
                   else A (env(V x)) u
step (A (L x t) u) = subst x u t
step (A t u) = if hasredex t then A (step t) u else A t (step u)


steps :: T -> [T]
steps t = takeUntil normal (iterate step t)

takeUntil p [] = []
takeUntil p (x:l) = x : if p x then [] else takeUntil p l

-- Normal form:

nf :: T -> T
nf = last.steps

-- Another feature for the user:

data Redex = NameExpansion Variable | Beta T | Eta T | None

redex :: T -> Redex
redex (V x) = if env(V x) /= V x then NameExpansion x else None
redex (L x t) = if wantEtaReduction
                   then case t of
                          A u (V y) -> if x == y && not(free x u)
                                       then Eta(L x t)
                                       else redex t
                          otherwise -> redex t
                   else redex t
redex (A (V x) u) = if env(V x) /= V x then NameExpansion x else redex u
redex (A (L x t) u) = Beta(A (L x t) u)
redex (A t u) = if hasredex t then redex t else redex u

redexes :: T -> [Redex]
redexes t = map redex (steps t)

-- alpha-equivalence.
-- We use De Bruijn indices for this.

data B = Vb Variable             
       | Ib N             
       | Lb B
       | Ab B B
     deriving (Show,Eq)

-- Lambda abstraction algorithm.
-- We abstract the varible x from the de Bruijn term t
-- (then it disappears from t).

lam :: Variable -> B -> B
lam x t = Lb (h 0 t)
 where h n (Vb y) = if x == y then Ib n else Vb y
       h n (Ib i) = Ib i
       h n (Lb t) = Lb (h (n+1) t)
       h n (Ab t u) = Ab (h n t) (h n u)

-- alpha is a quotient with alpha-equivalence as its kernel:

alpha :: T -> B
alpha (V x) = Vb x
alpha (L x t) = lam x (alpha t)
alpha (A t u) = Ab (alpha t) (alpha u)

-- eta-beta-alpha equivalence:

same :: T -> T -> Bool
same t u = alpha(nf t) == alpha(nf u)

-- Output functions

ssteps :: T -> IO ()
ssteps t = interact(\s -> concat (map (++"\n") (map show (steps t))))

sredexes :: T -> IO()
sredexes t = interact(\s -> concat (map (++"\n") (map show (redexes t))))

instance Show T where
  show = unparse

shown (a,n) = a ++ if n == 0 then "" else show n

unparse (V x) = shown x
unparse (L x t) = "\\" ++ shown x ++ "." ++ unparse t
unparse (A s t) = unparsel s ++ " " ++ unparser t

unparsel (V x) = shown x
unparsel (L x t) = "(\\" ++ shown x ++ "." ++ unparse t ++ ")"
unparsel (A s t) = unparsel s ++ " " ++ unparser t

unparser (V x) = shown x
unparser (L x t) = "(\\" ++ shown x ++ "." ++ unparse t ++ ")"
unparser (A s t) = "(" ++ unparsel s ++ " " ++ unparser t ++ ")"

instance Show Redex where
   show (NameExpansion x) = "Name redex: " ++ shown x
   show (Beta t) = "Beta redex: " ++ show t
   show (Eta t) = "Eta  redex:" ++ show t
   show None = ""

-- Proof of the selection monad properties.
-- (The proof is printed, but we can also get a yes/no
--  answer if we wish.)

-- First define variable names:

a = V("a",0)
x = V("x",0)
y = V("y",0)
z = V("z",0)
f = V("f",0)
g = V("g",0)
h = V("h",0)
e = V("e",0)
bige = V("E",0)
bigphi = V("Phi",0)
phi = V("phi",0)
bigu = V("U",0)
bigp = V("P",0)
bigq = V("Q",0)
p = V("p",0)
q = V("q",0)

la = L("a",0)
lx = L("x",0)
ly = L("y",0)
lz = L("z",0)
lf = L("f",0)
lg = L("g",0)
lh = L("h",0)
le = L("e",0)
lbige = L("E",0)
lbigphi = L("Phi",0)
lphi = L("phi",0)
lbigu = L("U",0)
lp = L("p",0)
lq = L("q",0)

s = V("s",0)
eta = V("eta",0)
mu = V("mu",0)
t = V("t",0)
qeta = V("qeta",0)
qmu = V("qmu",0)
forsome = V("forsome",0)

-- Now define the environment with names for the terms we want to study:

env (V(name,n)) = en name
 where -- selection monad
       en "s" = lf (le (lq (A f (A e (la (A q (A f a)))))))
       en "eta" = lx (lp x)
       en "mu" = lbige (lp (A (A bige (le (A p (A e p)))) p))
       -- continuation monad
       en "t" = lf (lphi(lp (A phi(lx (A p(A f x))))))
       en "qeta" = lx(lp (A p x))
       en "qmu" = lbigphi(lbigu (A bigphi(lphi(A phi bigu))))
       -- morphism from the first to the second monad
       en "forsome" = le(lp(A p(A e p)))
       en _  = V(name,n)

-- Macros. Warning: assume that "x" is not free in u and v for composition.

comp u v = lx(A u (A v x))
sfunctor u = A s u
tfunctor u = A t u

-- Now the equations we want to verify:

functorial1 = lg(lf(comp (sfunctor g) (sfunctor f))) 
functorial2 = lg(lf(sfunctor (comp g f)))
naturaleta1 = lf(comp (sfunctor f) eta)
naturaleta2 = lf(comp eta f)
naturalmu1 = lf(comp (sfunctor f) mu)
naturalmu2 = lf(comp mu (sfunctor (sfunctor f)))
unit1 =  comp mu (sfunctor eta)
unit2 =  comp mu eta
identity = lx x
assoc1 = comp mu (sfunctor mu)
assoc2 = comp mu mu


-- No need to verify the next chunk, as this is well known:

qfunctorial1 = lg(lf(comp (tfunctor f) (tfunctor g))) 
qfunctorial2 = lg(lf(tfunctor (comp f g)))
qnaturaleta1 = lf(comp (tfunctor f) qeta)
qnaturaleta2 = lf(comp qeta f)
qnaturalmu1 = lf(comp (tfunctor f) qmu)
qnaturalmu2 = lf(comp qmu (tfunctor(tfunctor f)))
qunit1 = comp qmu (tfunctor qeta)
qunit2 = comp qmu qeta
qassoc1 = comp qmu (tfunctor qmu)
qassoc2 = comp qmu qmu

-- But we need to check this:

naturalforsome1 = lf(comp forsome (sfunctor f))
naturalforsome2 = lf(comp (tfunctor f) forsome)
morphismeta1 = comp forsome eta
morphismeta2 = qeta
morphismmu1 = comp qmu (comp forsome (sfunctor forsome))
morphismmu2 = comp forsome mu

equations =  [ (functorial1, functorial2),         -- (s,eta,mu) is a monad
               (naturaleta1, naturaleta2),        
               (naturalmu1, naturalmu2),
               (unit1, unit2),                     -- only this one requires eta-reduction
               (unit2, identity),                        
               (assoc1, assoc2), 
               -- (qfunctorial1, qfunctorial2),       -- (t,qeta,qmu) is a monad
               -- (qnaturaleta1, qnaturaleta2),
               -- (qnaturalmu1, qnaturalmu2),
               -- (qunit1, qunit2),
               -- (qassoc1, qassoc2), 
               (naturalforsome1, naturalforsome2), -- forsome is a morphism s->t
               (morphismeta1, morphismeta2),
               (morphismmu1, morphismmu2) ]

verification :: Bool
verification = and [same t1 t2 | (t1,t2) <- equations]

terms =  [     functorial1, functorial2,         
               naturaleta1, naturaleta2,        
               naturalmu1, naturalmu2,
               unit1, unit2,                 
               assoc1, assoc2,
               -- qfunctorial1, qfunctorial2,   
               -- qnaturaleta1, qnaturaleta2,
               -- qnaturalmu1, qnaturalmu2,
               -- qunit1, qunit2,
               -- qassoc1, qassoc2, 
               naturalforsome1, naturalforsome2,
               morphismeta1, morphismeta2,
               morphismmu1, morphismmu2 
         ]

derivations = [ (steps t, redexes t) | t <- terms]

textderivations :: String
textderivations = concat [ concat(map (++ "\n") (map show (steps t))) ++ "\n" ++
                           concat(map (++ "\n") (map show (redexes t))) ++ "\n\n" 
                              | t <- terms]

-- This prints the derivation of all the equations:

main = interact(\s -> textderivations)

-- This only works with eta reduction enabled:

{- Result of the verification

*Main> verification
True

Here is a detailed step-by-step verification of one of the equations:

*Main> ssteps assoc1
\x.mu (s mu x)
\x.(\E.\p.E (\e.p (e p)) p) (s mu x)
\x.\p.s mu x (\e.p (e p)) p
\x.\p.(\f.\e.\q.f (e (\a.q (f a)))) mu x (\e.p (e p)) p
\x.\p.(\e.\q.mu (e (\a.q (mu a)))) x (\e.p (e p)) p
\x.\p.(\q.mu (x (\a.q (mu a)))) (\e.p (e p)) p
\x.\p.mu (x (\a.(\e.p (e p)) (mu a))) p
\x.\p.(\E.\p.E (\e.p (e p)) p) (x (\a.(\e.p (e p)) (mu a))) p
\x.\p.(\p1.x (\a.(\e.p (e p)) (mu a)) (\e.p1 (e p1)) p1) p
\x.\p.x (\a.(\e.p (e p)) (mu a)) (\e.p (e p)) p
\x.\p.x (\a.p (mu a p)) (\e.p (e p)) p
\x.\p.x (\a.p ((\E.\p.E (\e.p (e p)) p) a p)) (\e.p (e p)) p
\x.\p.x (\a.p ((\p.a (\e.p (e p)) p) p)) (\e.p (e p)) p
\x.\p.x (\a.p (a (\e.p (e p)) p)) (\e.p (e p)) p

*Main> :r -- needed reinstate the handle. This is a ghci I/O bug.
Ok, modules loaded: Main.

*Main> ssteps assoc2
\x.mu (mu x)
\x.(\E.\p.E (\e.p (e p)) p) (mu x)
\x.\p.mu x (\e.p (e p)) p
\x.\p.(\E.\p.E (\e.p (e p)) p) x (\e.p (e p)) p
\x.\p.(\p.x (\e.p (e p)) p) (\e.p (e p)) p
\x.\p.x (\e.(\e.p (e p)) (e (\e.p (e p)))) (\e.p (e p)) p
\x.\p.x (\e.p (e (\e.p (e p)) p)) (\e.p (e p)) p

Here is another example:

*Main> ssteps morphismmu1
\x.qmu ((\x.forsome (s forsome x)) x)
\x.(\Phi.\U.Phi (\phi.phi U)) ((\x.forsome (s forsome x)) x)
\x.\U.(\x.forsome (s forsome x)) x (\phi.phi U)
\x.\U.forsome (s forsome x) (\phi.phi U)
\x.\U.(\e.\p.p (e p)) (s forsome x) (\phi.phi U)
\x.\U.(\p.p (s forsome x p)) (\phi.phi U)
\x.\U.(\phi.phi U) (s forsome x (\phi.phi U))
\x.\U.s forsome x (\phi.phi U) U
\x.\U.(\f.\e.\q.f (e (\a.q (f a)))) forsome x (\phi.phi U) U
\x.\U.(\e.\q.forsome (e (\a.q (forsome a)))) x (\phi.phi U) U
\x.\U.(\q.forsome (x (\a.q (forsome a)))) (\phi.phi U) U
\x.\U.forsome (x (\a.(\phi.phi U) (forsome a))) U
\x.\U.(\e.\p.p (e p)) (x (\a.(\phi.phi U) (forsome a))) U
\x.\U.(\p.p (x (\a.(\phi.phi U) (forsome a)) p)) U
\x.\U.U (x (\a.(\phi.phi U) (forsome a)) U)
\x.\U.U (x (\a.forsome a U) U)
\x.\U.U (x (\a.(\e.\p.p (e p)) a U) U)
\x.\U.U (x (\a.(\p.p (a p)) U) U)
\x.\U.U (x (\a.U (a U)) U)

*Main> length(steps morphismmu1)
19

*Main> ssteps morphismmu2
\x.forsome (mu x)
\x.(\e.\p.p (e p)) (mu x)
\x.\p.p (mu x p)
\x.\p.p ((\E.\p.E (\e.p (e p)) p) x p)
\x.\p.p ((\p.x (\e.p (e p)) p) p)
\x.\p.p (x (\e.p (e p)) p)

We can see which redexes were reduced above:

*Main> sredexes morphismmu1
Name redex: qmu
Beta redex: (\Phi.\U.Phi (\phi.phi U)) ((\x.forsome (s forsome x)) x)
Beta redex: (\x.forsome (s forsome x)) x
Name redex: forsome
Beta redex: (\e.\p.p (e p)) (s forsome x)
Beta redex: (\p.p (s forsome x p)) (\phi.phi U)
Beta redex: (\phi.phi U) (s forsome x (\phi.phi U))
Name redex: s
Beta redex: (\f.\e.\q.f (e (\a.q (f a)))) forsome
Beta redex: (\e.\q.forsome (e (\a.q (forsome a)))) x
Beta redex: (\q.forsome (x (\a.q (forsome a)))) (\phi.phi U)
Name redex: forsome
Beta redex: (\e.\p.p (e p)) (x (\a.(\phi.phi U) (forsome a)))
Beta redex: (\p.p (x (\a.(\phi.phi U) (forsome a)) p)) U
Beta redex: (\phi.phi U) (forsome a)
Name redex: forsome
Beta redex: (\e.\p.p (e p)) a
Beta redex: (\p.p (a p)) U

Another example (only one in which eta-reduction is used):

*Main> ssteps unit1
\x.mu (s eta x)
\x.(\E.\p.E (\e.p (e p)) p) (s eta x)
\x.\p.s eta x (\e.p (e p)) p
\x.\p.(\f.\e.\q.f (e (\a.q (f a)))) eta x (\e.p (e p)) p
\x.\p.(\e.\q.eta (e (\a.q (eta a)))) x (\e.p (e p)) p
\x.\p.(\q.eta (x (\a.q (eta a)))) (\e.p (e p)) p
\x.\p.eta (x (\a.(\e.p (e p)) (eta a))) p
\x.\p.(\x.\p.x) (x (\a.(\e.p (e p)) (eta a))) p
\x.\p.(\p1.x (\a.(\e.p (e p)) (eta a))) p
\x.\p.x (\a.(\e.p (e p)) (eta a))
\x.\p.x (\a.p (eta a p))
\x.\p.x (\a.p ((\x.\p.x) a p))
\x.\p.x (\a.p ((\p.a) p))
\x.\p.x (\a.p a)
\x.\p.x p
\x.x

*Main> sredexes unit1
Name redex: mu
Beta redex: (\E.\p.E (\e.p (e p)) p) (s eta x)
Name redex: s
Beta redex: (\f.\e.\q.f (e (\a.q (f a)))) eta
Beta redex: (\e.\q.eta (e (\a.q (eta a)))) x
Beta redex: (\q.eta (x (\a.q (eta a)))) (\e.p (e p))
Name redex: eta
Beta redex: (\x.\p.x) (x (\a.(\e.p (e p)) (eta a)))
Beta redex: (\p1.x (\a.(\e.p (e p)) (eta a))) p
Beta redex: (\e.p (e p)) (eta a)
Name redex: eta
Beta redex: (\x.\p.x) a
Beta redex: (\p.a) p
Eta  redex:\a.p a
Eta  redex:\p.x p

*Main> ssteps unit2
\x.mu (eta x)
\x.(\E.\p.E (\e.p (e p)) p) (eta x)
\x.\p.eta x (\e.p (e p)) p
\x.\p.(\x.\p.x) x (\e.p (e p)) p
\x.\p.(\p.x) (\e.p (e p)) p
\x.\p.x p
\x.x

*Main> sredexes unit2
Name redex: mu
Beta redex: (\E.\p.E (\e.p (e p)) p) (eta x)
Name redex: eta
Beta redex: (\x.\p.x) x
Beta redex: (\p.x) (\e.p (e p))
Eta  redex:\p.x p

 -}
