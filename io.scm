(define-module
  (mro io)
  #:use-module ((rnrs io ports) #:select (get-bytevector-n! put-bytevector))
  #:export (copy-port))

(define* (copy-port producer consumer #:optional (block-size 4096))
  "Copies from producer port to consumer port.
   Returns total number of bytes read from producer port."
  (let ((buffer (make-generalized-vector 'u8 block-size))
        (n-bytes-copied 0))
    (do
      ((n-read (get-bytevector-n! producer buffer 0 block-size)
               (get-bytevector-n! producer buffer 0 block-size)))
      ((eof-object? n-read) n-bytes-copied)
      (put-bytevector consumer buffer 0 n-read)
      (set! n-bytes-copied (+ n-bytes-copied n-read)))))
