#lang racket

(provide find_path
         find_node
         extend
         neighbors)


;; Finds the shorter path between two points
;; Returns a pair with the path as a list and the total weight
(define (find_path start end graph)
  (find_path_aux (list (list start)) end graph)
)

(define (find_path_aux paths end graph)
  (cond ((null? paths) '())
        ((equal? end (car paths)) (reverse (car paths)))
        (else (find_path_aux (append (extend (car paths) graph) (cdr paths)) end graph))
   )
)

;; Finds new paths following the given one
(define (extend paths graph)
  '()
)

;; Searchs for a given node in the graph
;; Retunrs the node and neighbors
(define (find_node node graph)
  (cond ((null? graph) '())
        ((equal? node (caar graph)) (car graph))
        (else (find_node node (cdr graph)))
   )
)

;; Return the neighbors from a node as a list
(define (neighbors node graph)
  (neighbors_aux (last (find_node node graph)) '())
)

(define (neighbors_aux pairs result)
  (cond ((null? pairs) result)
        (else  (neighbors_aux (cdr pairs) (append result (list(caar pairs)) )))
  )
)


  