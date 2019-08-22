#lang racket/gui

(require racket/gui
         racket/draw)
(require "../drawer/drawer.rkt")
(require "../graphCreator/graphCreator.rkt")
(require "../pathfinder/finder.rkt")


(define bitmap-blank
  (lambda [[w 0] [h #false] #:backing-scale [backing-scale 2.0]]
    (define width  (max 1 (exact-ceiling w)))
    (define height (max 1 (exact-ceiling (or h w))))
    (make-bitmap width height #:backing-scale backing-scale)))

;Resize bitmap
(define bitmap-scale
  (case-lambda
    [(bmp scale)
     (if (= scale 1.0) bmp (bitmap-scale bmp scale scale))]
    [(bmp scale-x scale-y)
     (cond [(and (= scale-x 1.0) (= scale-y 1.0)) bmp]
           [else (let ([w (max 1 (exact-ceiling (* (send bmp get-width) scale-x)))]
                       [h (max 1 (exact-ceiling (* (send bmp get-height) scale-y)))])
                   (define dc (make-object bitmap-dc% (bitmap-blank w h)))
                   (send dc set-smoothing 'aligned)
                   (send dc set-scale scale-x scale-y)
                   (send dc draw-bitmap bmp 0 0)
                   (or (send dc get-bitmap) (bitmap-blank)))])]))


(define logo (make-object bitmap% "../assets/logo.png"))
(define logou (make-object bitmap% "../assets/logounder.png"))

(define coords-list '())
(define edges-list '())
(define graph '())
(define weight 0)


;Pens
(define oneWay (make-object pen% "GAINSBORO" 4 'solid))
(define twoWay (make-object pen% "DIM GRAY" 4 'solid))
(define blackPen (make-object pen% "BLACK" 2 'solid))
(define whitePen (make-object pen% "SNOW" 1 'solid))


;Brushes
(define lightblue-brush (make-object brush% "LIGHTBLUE" 'solid))


;______________________M A I N   F R A ME ______________________
(define mainFrame (new frame% [label "Wazitico"]
                   [width 400]
                   [height 600]
                   [style '(no-resize-border)]))


(define mainPanelUp (new panel% [parent mainFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

(define mainPanelBottom (new panel% [parent mainFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))


(define (drawMain canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logo 0.3) 50 30))

(define (drawBottom canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logou 0.2) 0 0))


(define mainCanvasUp (new canvas% [parent mainPanelUp]
                                [paint-callback drawMain]))

(define mainCanvasBottom (new canvas% [parent mainPanelBottom]
                                [paint-callback drawBottom]))

(new button% [parent mainFrame]
             [label "Start"]
             [callback (lambda (button event)
                         (send mainFrame show #f)
                         (send cityFrame show #t))])

;______________________________________ C I T Y   F R A M E ______________
(define cityFrame (new frame% [label "Wazitico"]
                   [width 800]
                   [height 600]
                   [alignment '(center center)]))


(define cityPanel (new horizontal-panel% [parent cityFrame] ))
 

(define verticalPanel (new vertical-panel% [parent cityPanel]))


(define map-canvas (new canvas% [parent verticalPanel]
                       [style '(border)]
                       [vert-margin 10]  
                       [horiz-margin 10]
                       [min-height 500]
                       [min-width 870]                       
                       ))

(define dc (send map-canvas get-dc))



(define  horizontalPanelTwo (new horizontal-panel% [parent verticalPanel]
                     [alignment '(center center)]))


(define addCityButton (new button% [parent  horizontalPanelTwo]
             [label "Add City"]
             [vert-margin 10]  
             [horiz-margin 5]
             [callback (lambda (button event)
                         (send addCityFrame show #t)
                         )]))


(define addRoadButton (new button% [parent  horizontalPanelTwo]
             [label "Add Road"]
             [vert-margin 10]  
             [horiz-margin 5]
             [callback (lambda (button event)
                         (send roadFrame show #t)
        )]))

(define selectRouteButton (new button% [parent horizontalPanelTwo]
             [label "Select Route"]
             [vert-margin 10]  
             [horiz-margin 5]
             [callback (lambda (button event)
                         (send cityFrame show #t)
                         (clearCanvas)
                         (send tripFrame show #t))]))

(define (clearCanvas)
  (send cityFrame show #t)
  (sleep/yield 0.01)
  (draw-all-nodes)
  (draw-all-edges edges-list)
  )

(define weightLabel (new message% [parent horizontalPanelTwo]
                          [label (string-append "Complete weight: " (number->string weight))]))


;__________________________________ A D D    C I T Y ___________________________________

(define addCityFrame (new frame% [label "Add City"]
                   [width 140]
                   [height 180]
                   [alignment '(center center)]))

(define verticalCityPanel (new vertical-panel% [parent addCityFrame]
                     [alignment '(center center)]))


(define addCityLabel (new message% [parent verticalCityPanel]
                          [label "Name:"]))


(define addCityText ( new text-field% [parent verticalCityPanel]
                                    [label #f]
                                    [min-width 10]))


(define addX (new message% [parent verticalCityPanel]
                          [label "x:"]))


(define addXText ( new text-field% [parent verticalCityPanel]
                                    [label #f]
                                    [min-width 10] ))


(define addY (new message% [parent verticalCityPanel]
                          [label "y:"]))


(define addYText ( new text-field% [parent verticalCityPanel]
                                    [label #f]
                                    [min-width 10] ))


(define add-city-window-button (new button% [parent verticalCityPanel]
             [label "Ok"]
             [callback (lambda (button event)
                         (set! coords-list (append coords-list (list(list (send addCityText get-value) (send addXText get-value) (send addYText get-value)))))
                         (set! graph (addNode (send addCityText get-value) graph))
                         (draw-node (send addCityText get-value) (string->number (send addXText get-value)) (string->number (send addYText get-value))))]))


;__________________________________ R O A D   F R A M E __________________________________
(define roadFrame (new frame% [label "Add Route"]
                   [width 140]
                   [height 180]
                   [alignment '(center center)]))


(define verticalPanelRoute (new vertical-panel% [parent roadFrame]
                     [alignment '(center center)]))


(define roadInitialLabel (new message% [parent verticalPanelRoute]
                          [label "Origin"]))


(define roadInitialText (new text-field% [parent verticalPanelRoute]
                                    [label #f]
                                    [min-width 10]
                                    ))

(define roadFinalLabel (new message% [parent verticalPanelRoute]
                          [label "Destiny"]))


(define roadFinalText ( new text-field% [parent verticalPanelRoute]
                                    [label #f]
                                    [min-width 10]
                                    ))


(define roadLabel (new message% [parent verticalPanelRoute]
                          [label "Length"]))


(define roadText (new text-field% [parent verticalPanelRoute]
                                    [label #f]
                                    [min-width 10]
                                    ))


(define add-road-window-button (new button% [parent verticalPanelRoute]
             [label "Ok"]
             [callback (lambda (button event)
                         (define initialNode (send roadInitialText get-value))
                         (define finalNode (send roadFinalText get-value))
                         (define weight  (send roadText get-value))
                         (set! edges-list (append edges-list (list (list initialNode finalNode weight #t))))
                         (set! graph (addEdge initialNode finalNode (string->number weight) #t graph))
                         (draw-edge initialNode finalNode weight #t)
                         )]))



(define (draw-edge initialNode finalNode weight isDirected?)
  (draw-line dc initialNode finalNode isDirected?)                                              
  (number-draw weight initialNode finalNode)
  )

(define (draw-all-edges edges-list)
  (cond ((not(null? edges-list))
         (draw-edge (caar edges-list) (cadar edges-list) (caddar edges-list) (cadr(cddar edges-list)))
         (draw-all-edges (cdr edges-list)))
         ))

; DIBUJAR NODOS
(define (draw-all-nodes)
  (draw-all-nodes-aux coords-list)
  )


(define (draw-all-nodes-aux list)
  (cond ( (null? (cdr list) )
              (draw-node (caar list) (string->number (cadar list)) (string->number (caddar list)) )
           )
        (else
             (draw-node (caar list) (string->number (cadar list)) (string->number(caddar list)) )
             (draw-all-nodes-aux (cdr list))
         )))



(define (draw-node node x y)
  (send dc set-brush lightblue-brush)
  (send dc set-pen blackPen)
  (send dc draw-ellipse (- x 15) (- y 15) 30 30)
  (send dc set-pen blackPen)
  (send dc draw-text node (- x 10) (- y 10)))





;DIBUJAR CAMINOS
(define (draw-line dc origin destiny way)
  (cond ( (equal? way #t) ;una via
          (send
dc set-pen oneWay)
         )
        ((equal? way #f)
          (send dc set-pen twoWay)
         )
    )
  (send dc draw-line
        (getCoords origin "x") (getCoords origin "y")
        (getCoords destiny "x") (getCoords destiny "y") )
  )

(define (number-draw weight origin destiny) ;sqrt (x1-x2)^2+y^2  /2
  (define x (/ (+ (getCoords origin "x") (getCoords destiny "x")) 2))
  (define y (/ (+ (getCoords origin "y") (getCoords destiny "y")) 2))
  (send dc draw-text weight x y))
  



(define (getCoords nodo pos)
  (getCoordsAux nodo pos coords-list)
    )


(define (getCoordsAux nodo pos list)
  (cond( (null? list)
         -1)
       ( (equal? nodo (caar list))
         (cond( (equal? pos "x")
                (string->number(cadar list))
               )
              ( (equal? pos "y")
                (string->number(caddar list))
               )
              (else
               -1)
           )
        )
       (else
        (getCoordsAux nodo pos (cdr list))
        )
   )
)

(define (getPathCoords path)
  (cond ((null? path)
         '())
        (else
         (append
          (list (list (getCoords (car path) "x")(getCoords (car path) "y")))
          (getPathCoords (cdr path))))))

;; S T A R T   T R I P____________________________________________________________________
(define tripFrame (new frame% [label "Wazitico"]
                                     [width 200]
                                     [height 200]
                                     [style '(no-resize-border)]))

(define (toCityFromTrip)
  (send cityFrame show #t)
  (send tripFrame show #f))

(define msg (new message% [parent tripFrame]
                          [label "Ruta"]))

(define routeOrigin_entry (new text-field%
                          (label "Origin")
                          (parent tripFrame)
                          (init-value "")))

(define routeDestination_entry (new text-field%
                               (label "Destination")
                               (parent tripFrame)
                               (init-value "")))          


(new button% [parent tripFrame]
             [label "Ok"]
             [callback (lambda (button event)
                         (define paths (find_all_paths (send routeOrigin_entry get-value)
                                                       (send routeDestination_entry get-value)
                                                       graph))
                         (define shortestPath (min (cdr paths) (car paths) (path_distance (car paths) graph)))
                         (sleep/yield 0.5)
                         (draw_all_paths paths)
                         (draw_path_aux shortestPath "red")
                         (send weightLabel set-label (string-append "Complete weight: " (number->string (path_distance shortestPath graph))))
                         )])

(define (min paths pivot weight)
  (cond((null? paths)
        pivot)
       (else
        (cond ((< (path_distance (car paths) graph) weight)
               (min (cdr paths) (car paths) (path_distance (car paths) graph)))
              (else
               (min (cdr paths) pivot weight))))))

; Returns from ConfigScreen to MapScreen
(new button% [parent tripFrame]
             [label "Regresar al Mapa"]
             [callback (lambda (button event)
                         (toCityFromTrip))])


;; Draw path in the canvas
(define (draw_path_aux path color)
  (set_pen color 5 dc)
  (draw_path (getPathCoords path) dc)
  )

(define (draw_all_paths paths)
  (cond ((not(null? paths))
         (draw_path_aux (car paths) "blue")
         (draw_all_paths (cdr paths)))))
         


(send mainFrame show #t)