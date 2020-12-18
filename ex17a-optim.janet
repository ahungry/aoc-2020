# 4.5 seconds - much better
(var *pts* @[@[@[]]])
(def width 20)

(defn fill-pts []
  (set *pts* @[@[@[]]])
  (def ref *pts*)
  (for x 0 width
    (put ref x @[])
    (def ref (get ref x))
    (for y 0 width
      (put ref y @[])
      (def ref (get ref y))
      (for z 0 width
        (put ref z @{:x x :y y :z z})))))

(defn doto-pts
  "Apply F(x y z)"
  [f]
  (for x 0 width
    (for y 0 width
      (for z 0 width
        (f x y z)))))

(defn put-pt [x y z active? next]
  (def px (or (get *pts* x) @[]))
  (def py (or (get px y) @[]))
  (put py z @{:x x :y y :z z :active active? :next next}) nil)

(defn get-pt [x y z]
  (-> (get *pts* x) (get y) (get z)))

(defn get-neighbors [p]
  (if (p :x)
    (do
      (def neighbors @[])
      (for x (- (p :x) 1) (+ (p :x) 2)
        (for y (- (p :y) 1) (+ (p :y) 2)
          (for z (- (p :z) 1) (+ (p :z) 2)
            (array/push neighbors (get-pt x y z))
            )))
      neighbors)
    @[]))

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

(defn num-in-range [x xs]
  (length (filter (fn [y] (and y ((in-range x) y) (y :active))) xs)))

(defn n-in-range [n x] (= n (num-in-range x (get-neighbors x))))
(def two-in-range (partial n-in-range 2))
(def three-in-range (partial n-in-range 3))

(defn load-small []
  (string/replace-all "\n" "" (slurp "./ex17-small.txt")))

(defn get-active-state [x y w bytes]
  (= 35 (get bytes (+ (- x 1) (* w (- y 1))))))

(defn make-points [x y z w bytes]
  (for ix 1 x
    (for iy 1 y
      (for iz 1 z
        # Start our Z-layer at the halfway mark of everything
        (when (and (= iz (/ width 2)) (> ix 0) (> iy 0)
                   (<= ix w) (<= iy w))
          (when (get-active-state ix iy w bytes)
            (def ptr (get-pt (+ (/ width 2) ix)
                             (+ (/ width 2) iy) iz))
            (put ptr :active true)
            (pp "ACTIVE"))))))
  nil)

# Seed initial data
(fill-pts)
(make-points width width width 3 (load-small))

(defn next-trans [x]
  (if (x :active)
    (or (two-in-range x)
        (three-in-range x))
    (three-in-range x)))

(defn trans []
  (doto-pts (fn [x y z]
              (def pt (get-pt x y z))
              (put pt :next (next-trans pt))))
  (doto-pts (fn [x y z]
              (def pt (get-pt x y z))
              (put pt :active (pt :next)))))

(pp (length (filter (fn [x] (x :active)) (flatten *pts*))))
(pp "Go")
(trans)
(trans)
(trans)
(trans)
(trans)
(trans)
(pp "All done")
(pp (length (filter (fn [x] (x :active)) (flatten *pts*))))
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
(length (filter (fn [x] (x :active)) (flatten *pts*)))
# should be 21, getting 18.. fixed by increasin size

# should be 112
#(length (filter (fn [x] (x :active)) ps))
