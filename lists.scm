(define-module
  (mro lists)
  #:export (list-take))

(define (list-take l n)
  "Takes n elements from the list l from the beginning.
   Returns the n-element list."
  (define (helper l n acc)
    (if (or (= 0 n) (null? l))
      (reverse acc)
      (helper (cdr l) (- n 1) (cons (car l) acc))))
  (helper l n '()))
