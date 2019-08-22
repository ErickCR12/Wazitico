#lang racket/gui
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


(define logo (make-object bitmap% "assets/logo.png"))
(define logou (make-object bitmap% "assets/logounder.png"))

(define coords-list '() )
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
             [label "Add Route"]
             [vert-margin 10]  
             [horiz-margin 5]
             [callback (lambda (button event)
                         (send roadFrame show #t)
        )]))

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
                         (send weightLabel set-label (string-append "Complete weight: " (number->string weight)) ;meter aqui peso total
                         (draw-node dc (send addCityText get-value) (string->number (send addXText get-value)) (string->number (send addYText get-value)))))]))


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
                         (draw-line dc (send roadInitialText get-value) (send roadFinalText get-value) #t))]))



; DIBUJAR NODOS
(define (draw-all-nodes)
  (draw-all-nodes-aux coords-list dc)
  )


(define (draw-all-nodes-aux list dc)
  (cond ( (null? (cdr list) )
              (draw-node dc (caar list) (cadar list) (caddar list) )
           )
        (else
             (draw-node dc (caar list) (cadar list) (caddar list) )
             (draw-all-nodes-aux (cdr list) dc)
         )))



(define (draw-node dc node x y)
  (send dc set-brush lightblue-brush)
  (send dc set-pen blackPen)
  (send dc draw-ellipse (- x 15) (- y 15) 30 30)
  (send dc set-pen blackPen)
  (send dc draw-text node (- x 10) (- y 10)))





;DIBUJAR CAMINOS
(define (draw-line dc origin destiny way)
  (cond ( (equal? way #f) ;una via
          (send
dc set-pen oneWay)
         )
        ((equal? way #t)
          (send dc set-pen twoWay)
         )
    )
  (send dc draw-line
        ((getCoords origin "x")) ((getCoords origin "y"))
        ((getCoords destiny "x")) ((getCoords destiny "y")) )
  )



(define (getCoords nodo pos)
  (getCoordsAux nodo pos coords-list)
    )


(define (getCoordsAux nodo pos list)
  (cond( (null? list)
         -1)
       ( (equal? nodo (caar list))
         (cond( (equal? pos "x")
                (cadar list)
               )
              ( (equal? pos "y")
                (caddar list)
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


(send mainFrame show #t)