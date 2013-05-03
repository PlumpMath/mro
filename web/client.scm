(define-module
  (mro web client)
  #:use-module ((web client)
                #:renamer (symbol-prefix-proc 'web-client:))
  #:use-module ((web response)
                #:select (response-code response-headers)
                #:renamer (symbol-prefix-proc 'web-response:))
  #:export (http-get)
  #:re-export ((web-client:open-socket-for-uri . open-socket-for-uri)
               (web-client:http-head . http-head)
               (web-client:http-post . http-post)
               (web-client:http-put . http-put)
               (web-client:http-delete . http-delete)
               (web-client:http-trace . http-trace)
               (web-client:http-options . http-options)))

(define (http-get uri . args)
  "Connect to the server corresponding to uri and make the appropriate GET request.
   Returns two values: the response read from the server, and the response body as a string, bytevector, #f value, or as a port (if streaming? is true).

   Keyword arguments:
   #:body #f
        If body is not #f, a message body will also be sent with the HTTP request. If body is a string, it is encoded according to the content-type in headers, defaulting to UTF-8. Otherwise body should be a bytevector, or #f for no body. Although a message body may be sent with any request, usually only POST and PUT requests have bodies.
   #:port (open-socket-for-uri uri)
        If you already have a port open, pass it as port. Otherwise, a connection will be opened to the server corresponding to uri.
   #:version '(1 . 1)
   #:keep-alive? #f
        Unless keep-alive? is true, the port will be closed after the full response body has been read.
   #:headers '()
        Any extra headers in the alist headers will be added to the request.
   #:decode-body? #t
        If decode-body? is true, as is the default, the body of the response will be decoded to string, if it is a textual content-type. Otherwise it will be returned as a bytevector.
   #:streaming? #f
        However, if streaming? is true, instead of eagerly reading the response body from the server, this function only reads off the headers. The response body will be returned as a port on which the data may be read."
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
