(define-module
  (mro web client)
  #:use-module ((web client)
                #:select (http-get)
                #:renamer (symbol-prefix-proc 'web-client:))
  #:use-module ((web response)
                #:select (response-code response-headers)
                #:renamer (symbol-prefix-proc 'web-response:))
  #:export (http-get))

(define (http-get uri . args)
  (call-with-values
    (lambda () (apply web-client:http-get (cons uri args)))
    (lambda (response body)
      (let ((code (web-response:response-code response)))
       (if (or (= 301 code)     ; Moved Permanently 
               (= 302 code))    ; Found
         (let ((new-location
                 (cdr (assoc 'location
                             (web-response:response-headers response)))))
           (apply http-get (cons new-location args)))
         (values response body))))))
