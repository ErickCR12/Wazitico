#lang racket

(require "../pathfinder/finder.rkt")


;; Graph made for testing
(define test_graph
    '(
     (a ((b 5) (c 8)))
     (b ((c 6) (d 7)))
     (c ((a 9) (d 2)))
     (d ((b 8) (a 1)))
     )
)

(define (run)
  ;; Find Node test
  (write (find_node 'a test_graph)) (newline)
  (write (find_node 'd test_graph)) (newline)
  (write (find_node 'e test_graph))
  )

(run)