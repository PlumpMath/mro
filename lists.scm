(define-module
  (mro lists)
  #:export (list-take))

(define (list-take l n)
  (define (helper l n acc)
    (if (or (= 0 n) (null? l))
      (reverse acc)
      (helper (cdr l) (- n 1) (cons (car l) acc))))
  (helper l n '()))
