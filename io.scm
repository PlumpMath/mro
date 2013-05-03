(define-module
  (mro io)
  #:use-module ((rnrs io ports) #:select (get-bytevector-n! put-bytevector))
  #:export (copy-port))

(define (copy-port producer consumer)
  (let ((buffer (make-generalized-vector 'u8 4096)))
    (do
      ((n-read (get-bytevector-n! producer buffer 0 4096)
               (get-bytevector-n! producer buffer 0 4096)))
      ((eof-object? n-read))
      (put-bytevector consumer buffer 0 n-read))))
