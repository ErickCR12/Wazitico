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


;; Finds a path from a to d using Deep First Search
(define (find_path_test)
  (cond ((and
         (equal? (find_path 'a 'd test_graph) '(a b c d) )
         (equal? (find_path 'a 'e test_graph) '() )  
         ) (print "OK find_path_test"))
        (else (print "FAILED find_path_test"))
   )
)

;; Finds all paths from a to d using Width First Search
(define (find_all_paths_test)
  (cond ((and
         (equal? (find_all_paths 'a 'd test_graph) '((a c d) (a b d) (a b c d)) )
         (equal? (find_all_paths 'a 'e test_graph) '() )  
         ) (print "OK find_all_paths_test"))
        (else (print "FAILED find_all_paths_test"))
   )
)

;; Find Node in Graph_test
(define (find_node_test)
  (cond ((and
         (equal? (find_node 'a test_graph) '(a ((b 5) (c 8))) )
         (equal? (find_node 'd test_graph) '(d ((b 8) (a 1))) )
         (equal? (find_node 'e test_graph) '() )
         ) (print "OK find_node_test"))
        (else (print "FAILED find_node_test"))
   )
)

;; Find the Neighbors of a Node in Graph_test
(define (neighbors_test)
  (cond ((and
         (equal? (neighbors 'a test_graph) '(b c) )
         (equal? (neighbors 'c test_graph) '(a d) )     
         ) (print "OK neighbors_test"))
        (else (print "FAILED neighbors_test"))
   )
)


;; Extends the paths to their neighbors
(define (extend_test)
  (cond ((and
         (equal? (extend '(a) test_graph) '((b a) (c a)) )
         (equal? (extend '(b a) test_graph) '((c b a) (d b a)) )
         (equal? (extend '(c b a) test_graph) '((d c b a)) )
         (equal? (extend '(c a) test_graph) '((d c a)) )
         ) (print "OK extend_test"))
        (else (print "FAILED extend_test"))
   )
)

;; Finds distance between two nodes
(define (nodes_distance_test)
  (cond ((and
         (equal? (nodes_distance 'a 'c test_graph) 8 )
         (equal? (nodes_distance 'd 'c test_graph) +inf.0 )
         ) (print "OK nodes_distance_test"))
        (else (print "FAILED nodes_distance_test"))
   )
)

;; Runs all finder tests
(define (run_finder)
  (print "[Finder Test]") (newline)
  (find_path_test) (newline)
  (find_all_paths_test) (newline)
  (find_node_test) (newline)
  (neighbors_test) (newline)
  (extend_test) (newline)
  (nodes_distance_test)
)