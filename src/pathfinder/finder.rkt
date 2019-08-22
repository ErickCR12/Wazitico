#lang racket

(provide find_path
         find_all_paths
         find_node
         extend
         neighbors
         path_distance
         nodes_distance)

(require "../util/list-functions.rkt")


;; Finds the shorter path between two points
;; Uses Deep First Search
;; Returns a pair with the path as a list and the total weight
(define (find_path start end graph)
  (find_path_aux (list (list start)) end graph)        
)

(define (find_path_aux paths end graph) 
  (cond ((null? paths) '())
        ((equal? end (caar paths)) (reverse (car paths)))
        (else (find_path_aux (append
                             (extend (car paths) graph)
                             (cdr paths))
                            end
                            graph))
   )
)


;; Finds all paths between two points
;; Uses Width First Search
(define (find_all_paths start end graph)
  (cond((not(null? graph))
        (find_all_paths_aux (list (list start)) end graph '()))
       (else
        '())
       )
)

(define (find_all_paths_aux paths end graph result)
  (cond ((null? paths) (reverse_all result))
        ((equal? end (caar paths)) (find_all_paths_aux (cdr paths)
                                                 end
                                                 graph
                                                 (cons (car paths) result)) )
        (else (find_all_paths_aux (append  
                             (extend (car paths) graph)
                             (cdr paths))
                            end
                            graph
                            result))
   )
)

    
;; Finds new paths following the given one
(define (extend path graph)
  (extend_aux (neighbors (car path) graph) '() path)
)

(define (extend_aux neighbors result path)
  (cond ((null? neighbors) result)
        ((member (car neighbors) path) (extend_aux (cdr neighbors) result path ))
        (else (extend_aux (cdr neighbors)
                          (append result (list(list* (car neighbors) path)))
                          path ))
   )
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
;; The node must exist
(define (neighbors node graph)
  (neighbors_aux (last (find_node node graph)) '())
)

(define (neighbors_aux pairs result)
  (cond ((null? pairs) result)
        (else  (neighbors_aux (cdr pairs) (append result (list(caar pairs)) )))
  )
)


;; Finds the distance for the path in the graph
(define (path_distance path graph)
  (cond ((null? path)
          -1)
         ((<= (length path) 1)
          0)
        (else (+ (nodes_distance (car path) (cadr path) graph)
                 (path_distance (cdr path) graph))))
)


;; Finds the distance between two nodes in a graph
(define (nodes_distance start end graph)
  (cond ((member end (neighbors start graph))
         (nodes_distance_aux end (last (find_node start graph))) )
        (else +inf.0)
  )
)

(define (nodes_distance_aux end neighbors)
  (cond ((equal? end (caar neighbors)) (last (car neighbors)))
        (else (nodes_distance_aux end (cdr neighbors)))
  )
)