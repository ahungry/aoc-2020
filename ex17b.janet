# 4.5 seconds - much better
# 4.5 seconds - much better
(var *pts* @[@[@[@[]]]])
(def width 24)

(defn fill-pts []
  (set *pts* @[@[@[@[]]]])
  (def ref *pts*)
  (for x 0 width
    (put ref x @[])
    (def ref (get ref x))
    (for y 0 width
      (put ref y @[])
      (def ref (get ref y))
      (for z 0 width
        (put ref z @[])
        (def ref (get ref z))
        (for w 0 width
          (put ref w @{:x x :y y :z z :w w}))))))

(defn doto-pts
  "Apply F(x y z w)"
  [f]
  (for x 0 width
    (for y 0 width
      (for z 0 width
        (for w 0 width
          (f x y z w))))))

(defn put-pt [x y z w active? next]
  (def px (or (get *pts* x) @[]))
  (def py (or (get px y) @[]))
  (def pz (or (get py z) @[]))
  (put pz w @{:x x :y y :z z :w w :active active? :next next}) nil)

(defn get-pt [x y z w]
  (-> (get *pts* x) (get y) (get z) (get w)))

(defn get-neighbors [p]
  (if (p :x)
    (do
      (def neighbors @[])
      (for x (- (p :x) 1) (+ (p :x) 2)
        (for y (- (p :y) 1) (+ (p :y) 2)
          (for z (- (p :z) 1) (+ (p :z) 2)
            (for w (- (p :w) 1) (+ (p :w) 2)
              (array/push neighbors (get-pt x y z w)))
            )))
      neighbors)
    @[]))

(fill-pts)
(length (get-neighbors {:x 5 :y 5 :z 5 :w 5}))

(defn in-range [x]
  (fn [y]
    (def x-diff (math/abs (- (x :x) (y :x))) )
    (def y-diff (math/abs (- (x :y) (y :y))) )
    (def z-diff (math/abs (- (x :z) (y :z))) )
    (def w-diff (math/abs (- (x :w) (y :w))) )
    (def n (+ x-diff y-diff z-diff w-diff))
    (and (> n 0) (<= n 3)
         (< x-diff 2)
         (< y-diff 2)
         (< z-diff 2)
         (< w-diff 2))))

(defn num-in-range [x xs]
  (length (filter (fn [y] (and y ((in-range x) y) (y :active))) xs)))

(defn n-in-range [n x] (= n (num-in-range x (get-neighbors x))))
(def two-in-range (partial n-in-range 2))
(def three-in-range (partial n-in-range 3))

(defn load-small []
  (string/replace-all "\n" "" (slurp "./ex17b-small.txt")))

(defn get-active-state [x y w bytes]
  (= 35 (get bytes (+ (- x 1) (* w (- y 1))))))

(defn make-points [x y z w ww bytes]
  (for ix 1 x
    (for iy 1 y
      (for iz 1 z
        (for iw 1 w
          # Start our Z-layer at the halfway mark of everything
          (when (and (= iw (/ width 2)) (> ix 0) (> iy 0) (= iz (/ width 2))
                     (<= ix ww) (<= iy ww))
            (when (get-active-state ix iy ww bytes)
              (def ptr (get-pt (+ (/ width 2) ix)
                               (+ (/ width 2) iy)
                               iz
                               iw))
              (put ptr :active true)
              (pp "ACTIVE")))))))
  nil)

# Seed initial data
(fill-pts)

(get-pt 1 3 5 5)


# TODO: Make match input width (3 or 8)
(make-points width width width width 3 (load-small))

(defn next-trans [x]
  (if (x :active)
    (or (two-in-range x)
        (three-in-range x))
    (three-in-range x)))

(defn trans []
  (doto-pts (fn [x y z w]
              (def pt (get-pt x y z w))
              (put pt :next (next-trans pt))))
  (doto-pts (fn [x y z w]
              (def pt (get-pt x y z w))
              (put pt :active (pt :next)))))

(pp (length (filter (fn [x] (x :active)) (flatten *pts*))))
(pp "Go")
(trans)
(pp "Go")
(trans)
(pp "Go")
(trans)
(pp "Go")
(trans)
(pp "Go")
(trans)
(pp "Go")
(trans)
(pp "All done")
(pp (length (filter (fn [x] (x :active)) (flatten *pts*))))
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
# (trans ps)
# (length (filter (fn [x] (x :active)) (flatten *pts*)))
# should be 21, getting 18.. fixed by increasin size

# should be 848
#(length (filter (fn [x] (x :active)) ps))

(pp "Was it 848?")
