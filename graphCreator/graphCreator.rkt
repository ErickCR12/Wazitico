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


(define (hasEdge? newNode edgesList)
  (cond ((null? edgesList)
         #f)
        ((equal? newNode (caar edgesList))
         #t)
        (else
         (hasEdge? newNode (cdr edgesList)))))


(define (addEdge originNode endNode weight)
  (cond ((and (hasNode? originNode graph) (hasNode? endNode graph))
         (set! graph (addEdgeAux originNode endNode weight graph)))))


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
                (append (list(car tempGraph)) (addEdgeAux originNode endNode weight (cdr tempGraph))))))
        (else
         (append (list(car tempGraph)) (addEdgeAux originNode endNode weight (cdr tempGraph))))))
         
  