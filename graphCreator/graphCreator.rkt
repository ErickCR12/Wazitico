#lang racket


(provide addNode
         addAllNodes
         addEdge)

;;hasNode?
;;Receives a node and a graph structure.
;;Returns a boolean indicating if the received node exists in the graph.
(define (hasNode? node graph)
  (cond ((null? graph)
         #f)
        ((equal? node (caar graph))
         #t)
        (else
         (hasNode? node (cdr graph)))))

;;addNode
;;Receives a node and a graph structure.
;;In case the node doesn't exists in the graph, it adds the new node into the graph.
(define (addNode newNode graph)
  (cond ((not(hasNode? newNode graph))
         (append graph (list (list newNode '()))))
        (else
         graph)))


;;addAllNodes
;;Receives a list containing nodes and a graph as parameters.
;;Adds every node in the received list into the graph.
(define (addAllNodes nodeList graph)
  (cond ((null? nodeList)
         graph)
        (else
         (addAllNodes (cdr nodeList) (addNode (car nodeList) graph)))))


;;hasEdge?
;;Receives a node and a list with edges of a node.
;;Checks if the node is already in the list of edges.
(define (hasEdge? newNode edgesList)
  (cond ((null? edgesList)
         #f)
        ((equal? newNode (caar edgesList))
         #t)
        (else
         (hasEdge? newNode (cdr edgesList)))))


;;addEdge
;;Receives an origin node and a end node to create a new edge in the graph. It also receives the weight of the edge and a boolean indicating
;; if it is directed or not
;;Return the graph with the new edge created.
(define (addEdge originNode endNode weight isDirected? graph)
  (cond ((and (hasNode? originNode graph) (hasNode? endNode graph))
         (cond (isDirected?
                (addEdgeAux originNode endNode weight graph))
               (else
                (addEdgeAux endNode originNode weight (addEdgeAux originNode endNode weight graph)))))
        (else
         '())))


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


  