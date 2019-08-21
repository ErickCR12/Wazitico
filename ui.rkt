#lang racket/gui
(require 2htdp/image)
;_______________________________________________________________________
;Blank bitmap for resize
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
;________________________________________________________________________

; I M A G E N E S
(define logo (make-object bitmap% "assets/logo.png"))
(define alajuela (make-object bitmap% "assets/alajuela.png"))
(define heredia (make-object bitmap% "assets/heredia.png"))
(define cartago (make-object bitmap% "assets/cartago.png"))
(define logoa (make-object bitmap% "assets/alajuelalogo.png"))
(define logoh (make-object bitmap% "assets/heredialogo.png"))
(define logoc (make-object bitmap% "assets/cartagologo.png"))
(define logou (make-object bitmap% "assets/logounder.png"))
;________________________________________________________________________

;________________________C O N E X I O N E S ____________________________
(define cartagoGraph '((SanNicolas((TresRios 2)))
                       (Occidental((SanNicolas 10) (Oriental 5)))
                       (Oriental((Occidental 5) (Cervantes 7)))
                       (Cervantes ((Oriental 7)))
                       (Pavones ((Cervantes 3)))
                       (TresRios((Guadalupe 5)))
                       (Guadalupe((Peralta 1) (SantaLucia 8)))
                       (Peralta((Guadalupe 1) (Turrialba 10)))
                       (Turrialba((JuanVinas 1)))
                       (JuanVinas((Pavones 4) (Tucurrique 8)))
                       (SanDiego((Concepcion 4)))
                       (SantaLucia((SanDiego 6) (Paraiso 7)))
                       (Paraiso((SantaLucia 7)))
                       (LaSuiza((Turrialba 6) (Paraiso 2) (Orosi 5)))
                       (Tucurrique((JuanVinas 8) (Santiago 10)))
                       (Concepcion((DulceNombre 2)))
                       (DulceNombre((SantaLucia 3) (Cachi 9)))
                       (Cachi((Orosi 7)))
                       (Orosi((LaSuiza 5)))
                       (Santiago((Orosi 9)))))

(define herediaGraph '((Mercedes((SanFrancisco 4)))
                       (Barva((Mercedes 8) (SantoDomingo 9) (SanPedro 5)))
                       (SantoDomingo((Barva 9) (Paracito 7)))
                       (Paracito((SantoDomingo 7) (SantoTomas 7)))
                       (LaVirgen((Paracito 2) (Horquetas 1)))
                       (SanFrancisco((Mercedes 4) (SanPedro 4)))
                       (SanPedro((SanVicente 3) (SantaLucia 2)))
                       (SanVicente((SanPedro 3) (SantoDomingo 6) (SantoTomas 8)))
                       (SantoTomas((SanVicente 8) (Horquetas 10) (SanRafael 9)))
                       (Horquetas((LaVirgen 1) (Tures 3)))
                       (VaraBlanca((SantaLucia 1)))
                       (SantaLucia((SanPedro 2) (VaraBlanca 1)))
                       (SanMiguel((SantaLucia 10) (SanRafael 6)))
                       (SanRafael((SanMiguel 6)))
                       (Tures((Horquetas 3) (SanRafael 5)))))

(define alajuelaGraph '((SanAntonio((Guacima 4)))
                       (Guacima((Turrucares 6) (Sabanilla 9)))
                       (Turrucares((LaFortuna 1) (Grecia 8)))
                       (LaFortuna((Turrucares 1) (Zarcero 5)))
                       (Zarcero((LaFortuna 5) (Palmares 3)))
                       (Carriazal((San Antonio 2) (Sabanilla 9)))
                       (Sabanilla((Carriazal 9) (Guacima 9) (Grecia 2)))
                       (Grecia((Atenas 1)))
                       (Atenas((LaFortuna 10)))
                       (Palmares((Atenas 7)))))
;________________________________________________________________________
;Main Frame
(define mainFrame (new frame% [label "Wazitico"]
                   [width 400]
                   [height 600]
                   [style '(no-resize-border)]))

;Main Panel
(define mainPanelUp (new panel% [parent mainFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

(define mainPanelBottom (new panel% [parent mainFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

;Drawer
(define (drawMain canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logo 0.3) 50 30))

(define (drawBottom canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logou 0.2) 0 0))

;Main Canvas
(define mainCanvasUp (new canvas% [parent mainPanelUp]
                                [paint-callback drawMain]))

(define mainCanvasBottom (new canvas% [parent mainPanelBottom]
                                [paint-callback drawBottom]))

(define (toCityFrame)
  (send mainFrame show #f)
  (send cityFrame show #t))

(new button% [parent mainFrame]
             [label "Start"]
             [callback (lambda (button event)
                         (toCityFrame))])

; S E L E C C I O N A R   C I U D A D __________________________________________
(define cityFrame (new frame% [label "Wazitico"]
                                     [width 400]
                                     [height 600]
                                     [style '(no-resize-border)]))

(define cityPanelUp (new panel% [parent cityFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

(define cityPanelMedium (new panel% [parent cityFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

(define cityPanelBottom (new panel% [parent cityFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))
;Drawer
(define (drawCityUp canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logoa 0.1) 0 0))

(define (drawCityMedium canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logoh 0.46) 0 -30))

(define (drawCityBottom canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale logoc 0.21) 0 -40))

;City Canvas
(define mainCityUp (new canvas% [parent cityPanelUp]
                                [paint-callback drawCityUp]))

(define mainCityMedium (new canvas% [parent cityPanelMedium]
                                [paint-callback drawCityMedium]))

(define mainCityBottom (new canvas% [parent cityPanelBottom]
                                [paint-callback drawCityBottom]))

(define (toAlajuela)
  (send cityFrame show #f)
  (send alajuelaFrame show #t))

(define (toHeredia)
  (send cityFrame show #f)
  (send herediaFrame show #t))

(define (toCartago)
  (send cityFrame show #f)
  (send cartagoFrame show #t))

(new button% [parent cityFrame]
             [label "Alajuela"]
             [callback (lambda (button event)
                         (toAlajuela))])

(new button% [parent cityFrame]
             [label "Heredia"]
             [callback (lambda (button event)
                         (toHeredia))])

(new button% [parent cityFrame]
             [label "Cartago"]
             [callback (lambda (button event)
                         (toCartago))])
;________________________________________________________________________________
;Alajuela Frame
(define alajuelaFrame (new frame% [label "Wazitico: Alajuela"]
                   [width 910]
                   [height 380]
                   [style '(no-resize-border)]))

(define alajuelaPanel (new panel% [parent alajuelaFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

;Drawer
(define (drawAlajuela canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale alajuela 0.4) 0 0))


;Main Canvas
(define alajuelaCanvas (new canvas% [parent alajuelaPanel]
                                [paint-callback drawAlajuela]))

(define (toRouteA)
  (send alajuelaFrame show #f)
  (send routeFrame show #t))


(new button% [parent alajuelaFrame]
             [label "Select Route..."]
             [callback (lambda (button event)
                         (toRouteA))])

;________________________________________________________________________________
;Heredia Frame
(define herediaFrame (new frame% [label "Wazitico: Heredia"]
                   [width 900]
                   [height 585]
                   [style '(no-resize-border)]))

(define herediaPanel (new panel% [parent herediaFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

;Drawer
(define (drawHeredia canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale heredia 0.4) 0 0))


(define herediaCanvas (new canvas% [parent herediaPanel]
                                [paint-callback drawHeredia]))

(define (toRouteH)
  (send herediaFrame show #f)
  (send routeFrame show #t))


(new button% [parent herediaFrame]
             [label "Select Route..."]
             [callback (lambda (button event)
                         (toRouteH))])

;________________________________________________________________________________
;Cartago Frame
(define cartagoFrame (new frame% [label "Wazitico: Cartago"]
                   [width 680]
                   [height 600]
                   [style '(no-resize-border)]))

(define cartagoPanel (new panel% [parent cartagoFrame]
                             [border 0]
                             [spacing 0]
                             [alignment '(center center)]))

;Drawer
(define (drawCartago canvas dc)
  (send dc set-scale 2 2)
  (send dc draw-bitmap (bitmap-scale cartago 0.3) 0 0))


(define cartagoCanvas (new canvas% [parent cartagoPanel]
                                [paint-callback drawCartago]))

(define (toRouteC)
  (send cartagoFrame show #f)
  (send routeFrame show #t))


(new button% [parent cartagoFrame]
             [label "Select Route..."]
             [callback (lambda (button event)
                         (toRouteC))])

; R O U T E ____________________________________________________________________
(define routeFrame (new frame% [label "Wazitico"]
                                     [width 600]
                                     [height 400]
                                     [style '(no-resize-border)]))

(define (toCityFromRoute)
  (send cityFrame show #t)
  (send routeFrame show #f))

(define msg (new message% [parent routeFrame]
                          [label "Configuración de Ruta y Nodos"]))

(define routeOrigin_entry (new text-field%
                          (label "Origin")
                          (parent routeFrame)
                          (init-value "")))

(define routeDestination_entry (new text-field%
                               (label "Destination")
                               (parent routeFrame)
                               (init-value "")))          

(define routeNumber (new text-field% [parent routeFrame]
                                     [label "Número de ruta que quiere seguir:       "]))

(define (pathGetter)
  (let ([origin (send routeOrigin_entry get-value)]
         [destination (send routeDestination_entry get-value)])
    (cond ((equal? origin destination)
         (display origin))
        (else (display destination)))))


(new button% [parent routeFrame]
             [label "Ok"]
             [callback (lambda (button event)
                         (toCityFromRoute))])

; Returns from ConfigScreen to MapScreen
(new button% [parent routeFrame]
             [label "Regresar al Mapa"]
             [callback (lambda (button event)
                         (toCityFromRoute))])

(send mainFrame show #t)