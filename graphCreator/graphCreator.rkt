#lang racket

(define graph '())

(define (hasNode? node graph)
  (cond ((null? graph)
         #f)
        ((equal? node (caar graph))
         #t)
        (else
         (hasNode? node (cdr graph)))))
         

(define (addNode newNode)
  (cond ((not(hasNode? newNode graph))
         (set! graph (append graph (list (list newNode '())))))))

(define (addAllNodes nodeList)
  (cond ((not(null? nodeList))
         (addNode (car nodeList))
         (addAllNodes (cdr nodeList)))))

