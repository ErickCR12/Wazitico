#lang racket

(require "../../drawer/drawer.rkt")


;; Creates a bitmap and saves it as png
(define (test)
  
  (define bm (make_bitmap 500 500)) ;; Creates a BitMap [width height]
  (define dc (make_dc "red" 30 bm)) ;; Sets the DC pen [color width] from BitMap

  ;; Draws path A
  (draw_path '((100 100) (100 150) (150 150) (150 200)
               (250 200) (250 450) (400 450) ) dc)

  ;; Draws path B
  (set_pen "blue" 30 dc)
  (draw_path '((300 100) (300 300) (150 300) (150 400)
               (400 400) (400 200) (450 200) ) dc)

  ;; Draws path C
  (set_pen "green" 20 dc)
  (draw_path '((30 30) (480 30) (480 450) ) dc)

  ;; Saves the BM as PNG
  (save bm "test.png")
)
(test)