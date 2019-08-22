#lang racket

(require "pathfinder/finder-test.rkt")
(require "../test/graphCreator/graph-test.rkt")

;; Runs all different module's tests
(define (run)
  (run_finder)
  (run_creator))

(run)