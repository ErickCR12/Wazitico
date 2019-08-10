#lang racket

(provide find_path
         find_node)


;; Finds the shorter path between two points
;; Returns a pair with the path as a list and the total weight
(define (find_path graph start end)
  (find_path_aux))

;;
(define (find_path_aux graph)
  '()
)

;; Searchs for a given node in the graph
;; Retunrs the node and neighbors
(define (find_node node graph)
  (cond ((null? graph) '())
        ((equal? node (caar graph)) (car graph))
        (else (find_node node (cdr graph)))
        ))