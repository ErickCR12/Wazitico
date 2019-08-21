#lang racket

(require racket/gui
         racket/draw)

(provide make_bitmap
         make_dc
         set_pen
         draw_path
         save)


;; Instantiates a BitMap
(define (make_bitmap w h)
  (define bm (make-bitmap w h))
  bm
)


;; Instantiates a Drawing Context
(define (make_dc color width  bm)
  (define dc (new bitmap-dc% [bitmap bm]))
  (send dc set-pen color width 'solid)
  dc
)


;; Set the pen color and width from the given DC
(define (set_pen color width dc)
  (send dc set-pen color width 'solid)
  dc
)
  

;; Draws a BitMap in the given drawing context
(define (draw_path nodes dc)
  (draw_path_aux (car nodes) (cadr nodes) (cdr nodes) dc))

(define (draw_path_aux nodeA nodeB nodes dc)
  (cond ((<= (length nodes) 1) (draw_line nodeA nodeB dc))
        (else
         (draw_line nodeA nodeB dc)
         (draw_path_aux (car nodes) (cadr nodes) (cdr nodes) dc))
   ))


;; Draw line from node A to B
(define (draw_line nodeA nodeB dc)
  (send dc draw-line
               (first nodeA) (last nodeA)
               (first nodeB) (last nodeB))
)


;; Saves the given bitmap as PNG file
(define (save bm name)
  (send bm save-file name 'png))