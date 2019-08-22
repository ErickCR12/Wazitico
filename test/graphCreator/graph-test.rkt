#lang racket

(provide run_creator)

(require "../../src/graphCreator/graphCreator.rkt")

(define graph '())

(define (addAllNodes_test)
  (set! graph (addAllNodes '(a a b c c c d e) graph))
  (cond ((equal? graph '((a())(b())(c())(d())(e())))
         (print "OK addAllNodes_test")(newline))
        (else
         (print "FAILED addAllNodes_test")(newline))))

(define (addNode_test)
  (set! graph (addNode 'f graph))
  (set! graph (addNode 'f graph))
  (set! graph (addNode 'g graph))
  (cond ((equal? graph '((a())(b())(c())(d())(e())(f())(g())))
         (print "OK addNode_test")(newline))
        (else
         (print "FAILED addNode_test")(newline))))

(define (addEdge_test)
  (set! graph (addEdge 'a 'b 5 #f graph))
  (set! graph (addEdge 'c 'd 4 #t graph))
  (set! graph (addEdge 'b 'f 3 #f graph))
  (set! graph (addEdge 'e 'g 2 #f graph))
  (set! graph (addEdge 'd 'f 1 #t graph))
  (set! graph (addEdge 'd 'f 1 #t graph))
  (set! graph (addEdge 'e 'g 2 #f graph))
  (cond ((equal? graph '((a((b 5)))(b((f 3)(a 5)))(c((d 4)))(d((f 1)))(e((g 2)))(f((b 3)))(g((e 2)))))
         (print "OK addEdge_test")(newline))
        (else
         (print "FAILED addEdge_test")(newline))))

(define (run_creator)
  (newline)(newline)(print "[Graph Creator Test]")(newline)
  (addAllNodes_test)
  (addNode_test)
  (addEdge_test)
  (print graph)
  (set! graph '()))

  


  