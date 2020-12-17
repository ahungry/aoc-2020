(defn in-range [x]
  (fn [y]
    (= 1 (+ (math/abs (- (x :x) (y :x)))
            (math/abs (- (x :y) (y :y)))
            (math/abs (- (x :z) (y :z)))))))

(assert (= false ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 1 :z 1})))
(assert (= true ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 0 :z 0})))

(defn num-in-range [x xs]
  (length (filter (in-range x) xs)))

(defn n-in-range [n x xs] (= (num-in-range x xs) n))
(def two-in-range (partial n-in-range 2))
(def three-in-range (partial n-in-range 3))

(two-in-range
 {:x 0 :y 0 :z 0}
 [
  {:x 1 :y 0 :z 0}
  {:x 1 :y 0 :z 0}
  {:x 0 :y 0 :z 0}
  ])

# .#.
# ..#
# ###
(defn load-small []
  (string/replace-all "\n" "" (slurp "./ex17-small.txt")))

(load-small)

(defn get-active-state [x y w bytes]
  (= 35 (get bytes (+ x (* w y)))))

(get-active-state 2 3 3 (load-small))

(defn make-points [x y z w bytes]
  (def start-x (* -1 x))
  (def points @[])
  (for ix start-x x
    (for iy (* -1 y) y
      (for iz (* -1 z) z
        (def p @{:x ix :y iy :z iz})
        (when (and (= iz 1) (> ix 0) (> iy 0))
          (when (get-active-state ix iy w bytes)
            (pp "ACTIVE!")
            (pp p)
            (put p :active true)))
        (array/push points p))))
  points)

(def ps (make-points 8 8 8 3 (load-small)))

(length ps)

# %% If a cube is active and exactly 2 or 3 of its neighbors are also
# %% active, the cube remains active.
# %% Otherwise, the cube becomes inactive.
# %% If a cube is inactive but exactly 3 of its neighbors are active,
# %% the cube becomes active. Otherwise, the cube remains inactive.

(defn next-trans [x xs]
  (if (x :active)
    (or (two-in-range x xs)
        (three-in-range x xs))
    (three-in-range x xs)))

(defn trans [xs]
  (map (fn [x]
         (put x :next (next-trans x xs))) xs)
  (map (fn [x]
         (put x :active (x :next))) xs))

(trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)

(length (filter (fn [x] (x :active)) ps))