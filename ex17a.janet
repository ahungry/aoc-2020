(defn in-range [x]
  (fn [y]
    (def x-diff (math/abs (- (x :x) (y :x))) )
    (def y-diff (math/abs (- (x :y) (y :y))) )
    (def z-diff (math/abs (- (x :z) (y :z))) )
    (def n (+ x-diff y-diff z-diff))
    (and (> n 0) (<= n 3)
         (< x-diff 2)
         (< y-diff 2)
         (< z-diff 2))))

(assert (= false ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 1 :z 1})))
(assert (= true ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 0 :z 0})))
(assert (= true ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 0 :z 0})))
(assert (= true ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 1 :z 0})))
(assert (= true ((in-range {:x 0 :y 0 :z 0}) {:x 1 :y 1 :z 1})))
(assert (= false ((in-range {:x 0 :y 0 :z 0}) {:x 2 :y 0 :z 0})))

(defn num-in-range [x xs]
  (length (filter (fn [y] (and ((in-range x) y)
                               (y :active))) xs)))

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

# After 1 transition (web sample was offset by 1 slot)
# z=0
# ...
# #.#
# .##
# .#.
(defn load-small []
  (string/replace-all "\n" "" (slurp "./ex17-small.txt")))

(load-small)

(defn get-active-state [x y w bytes]
  (= 35 (get bytes (+ (- x 1) (* w (- y 1))))))

(get-active-state 1 3 3 (load-small))

(defn make-points [x y z w bytes]
  (def points @[])
  (for ix (* -1 x) x
    (for iy (* -1 y) y
      (for iz (* -1 z) z
        (def p @{:x ix :y iy :z iz})
        (when (and (= iz 0) (> ix 0) (> iy 0)
                   (<= ix w) (<= iy w))
          (when (get-active-state ix iy w bytes)
            (pp "ACTIVE!")
            (pp p)
            (put p :active true)))
        (array/push points p))))
  points)

(def ps (make-points 9 9 9 3 (load-small)))

(length ps)

# %% If a cube is active and exactly 2 or 3 of its neighbors are also
# %% active, the cube remains active.
# %% Otherwise, the cube becomes inactive.
# %% If a cube is inactive but exactly 3 of its neighbors are active,
# %% the cube becomes active. Otherwise, the cube remains inactive.

# .#.
# ..#
# ###

# After 1 transition (web sample was offset by 1 slot)
# z=0
# ...
# #.#
# .##
# .#.

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

(pp "Go")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go2")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go3")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go4")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go5")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go6")
(trans ps)
(length (filter (fn [x] (x :active)) ps))
(pp "Go7")

# should be 112
(length (filter (fn [x] (x :active)) ps))
