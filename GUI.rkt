;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname GUI) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require racket/gui)

(define a "Alajuela")
(define b "Heredia")
(define c "Cartago")

(define mainframe (new frame% [label "Wazitico"]
                   [width 700]
                   [height 900]))

(define control-main (new horizontal-pane% [parent mainframe]
                                           [border 25]
                                           [spacing 25]
                                           [alignment '(center center)]))

(define secondframe (new frame% [label "Map"]
                   [width 500]
                   [height 500]))

(define control-second (new horizontal-pane% [parent secondframe]
                                           [border 25]
                                           [spacing 25]))

(define msg (new message% [parent mainframe]
                         [label "No events so far..."]))

;;________________________________ S E T   D Y N   N O D E S ______________________________
(define (alajuelamap)
  (cond ((>= i 500) 
             



;;(define (set nodes) 

;;_________________________________________________________________________________________


;;________________________ C A R G A  D E   M A P A________________________________________
(define (mapload ciudad)
  (cond ((equal? ciudad "Alajuela")
         (alajuelamap))
       ((equal? ciudad "Heredia")
         (set 15))
        (else
         (set 20))))
;;________________________________________________________________________________________




;;________________________ B O T O N  C U A D R A__________________________________________
(define (squarebtn text) (new button% [parent control-second] 
             [label text]
             [min-width 70]	 
             [min-height 70]
             [horiz-margin 20]
             [callback (lambda (button event)
                         (display #t))]))
(send mainframe show #t)
;;________________________________________________________________________________________





;;________________________ B O T O N E S __________________________________________________
(define alajuelabtn (new button% [parent control-main] 
             [label a]
             [min-width 30]	 
             [min-height 30]
             [horiz-margin 20]
             [callback (lambda (button event)
                         (send mainframe show #f)
                         (send secondframe show #t)
                         (mapload "Alajuela")
                         (send msg set-label  (string-append a " Selected")))]))
(send mainframe show #t)


(define herediabtn (new button% [parent control-main] 
             [label b]             
             [min-width 30]	 
             [min-height 30]
             [horiz-margin 20]
             [callback (lambda (button event)
                         (send mainframe show #f)
                         (send secondframe show #t)
                         (send msg set-label  (string-append a " Selected")))]))
(send mainframe show #t)

(define cartagobtn (new button% [parent control-main] 
             [label c]             
             [min-width 30]	 
             [min-height 30]
             [horiz-margin 20]
             [callback (lambda (button event)
                         (send mainframe show #f)
                         (send secondframe show #t)
                         (send msg set-label  (string-append a " Selected")))]))
(send mainframe show #t)
;;________________________________________________________________________________________


