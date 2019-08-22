#lang racket

(provide reverse_all)

;; Apply reverse to each sublist in a list
(define (reverse_all list)
  (reverse_all_aux list '())
)

(define (reverse_all_aux list result)
  (cond ((null? list) (reverse result) )
        (else (reverse_all_aux (cdr list)
                               (cons (reverse (car list))
                                     result) ))
  )
)