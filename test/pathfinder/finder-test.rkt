#lang racket

(require "../../pathfinder/finder.rkt")
(provide run_finder)

;; Graph made for testing
(define test_graph
    '(
     (a ((b 5) (c 8)))
     (b ((c 6) (d 7)))
     (c ((a 9) (d 2)))
     (d ((b 8) (a 1)))
     )
)

;; Find Node in Graph test
(define (find_node_test)
  (cond ((and
         (equal? (find_node 'a test_graph) '(a ((b 5) (c 8))) )
         (equal? (find_node 'd test_graph) '(d ((b 8) (a 1))) )
         (equal? (find_node 'e test_graph) '() )
         ) (print "OK find_node_test"))
        (else (print "FAILED find_node_test"))
   )
)

;; Runs all finder tests
(define (run_finder)
  (find_node_test)
)