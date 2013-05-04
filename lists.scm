(define-module
  (mro lists)
  #:export (list-take random-elt mappend))

(define (list-take l n)
  "Takes n elements from the list l from the beginning.
   Returns the n-element list."
  (define (helper l n acc)
    (if (or (= 0 n) (null? l))
      (reverse acc)
      (helper (cdr l) (- n 1) (cons (car l) acc))))
  (helper l n '()))

(define (random-elt l)
  "Returns a random element from the list l."
  (list-ref l (random (length l))))

(define (mappend f . args)
  "Maps f to the following list(s) and flattens the results."
  (apply append (apply map (cons f args))))
