#lang racket


(provide addNode
         addAllNodes
         addEdge)


(define (hasNode? node graph)
  (cond ((null? graph)
         #f)
        ((equal? node (caar graph))
         #t)
        (else
         (hasNode? node (cdr graph)))))

(define (addNode newNode graph)
  (cond ((not(hasNode? newNode graph))
         (append graph (list (list newNode '()))))
        (else
         graph)))


(define (addAllNodes nodeList graph)
  (addAllNodesAux nodeList graph))


(define (addAllNodesAux nodeList graph)
  (cond ((null? nodeList)
         graph)
        (else
         (addAllNodesAux (cdr nodeList) (addNode (car nodeList) graph)))))


(define (hasEdge? newNode edgesList)
  (cond ((null? edgesList)
         #f)
        ((equal? newNode (caar edgesList))
         #t)
        (else
         (hasEdge? newNode (cdr edgesList)))))


(define (addEdge originNode endNode weight isDirected? graph)
  (cond ((and (hasNode? originNode graph) (hasNode? endNode graph))
         (cond (isDirected?
                (addEdgeAux originNode endNode weight graph))
               (else
                (addEdgeAux endNode originNode weight (addEdgeAux originNode endNode weight graph)))))))


(define (addEdgeAux originNode endNode weight tempGraph)
  (cond ((null? tempGraph)
         '())
        ((equal? originNode (caar tempGraph))
         (cond ((not(hasEdge? endNode (cadar tempGraph)))
                (cond ((equal? (cadar tempGraph) '())
                       (append (list(list originNode (list (list endNode weight)))) (cdr tempGraph)))
                      (else
                       (append (list(list originNode (append (list (list endNode weight)) (cadar tempGraph)))) (cdr tempGraph)))))
               (else
                (append tempGraph (addEdgeAux originNode endNode weight '())))))
        (else
         (append (list(car tempGraph)) (addEdgeAux originNode endNode weight (cdr tempGraph))))))


  