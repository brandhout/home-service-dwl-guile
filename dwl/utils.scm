; Contains helper procedures and syntax macros
(define-module (dwl utils)
               #:use-module (guix gexp)
               #:use-module (srfi srfi-1)
               #:use-module (dwl bindings)
               #:export (
                         maybe-gexp?
                         maybe-string?
                         maybe-procedure?
                         modifier?
                         rgb-color?

                         list-of-strings?
                         list-of-modifiers?
                         list-of-tag-key-pairs?))

; General predicates
(define (maybe-string? val) (or (string? val) (not val)))
(define (maybe-procedure? val) (or (procedure? val) (not val)))
(define (maybe-gexp? val) (or (gexp? val) (not val)))
(define (modifier? val) (member val %modifiers))

; Validates the format of an RGBA list, e.g.
; '(0.2 0.5 0.6 1.0). Only values between 0-1 are allowed
; and no more than 4 elements may be present.
(define (rgb-color? lst)
  (and
    (equal? (length lst) 4)
    (every
      (lambda (v) (and (number? v) (and (>= v 0) (<= v 1))))
      lst)))

(define (list-of-strings? lst) (every string? lst))
(define (list-of-modifiers? lst) (every modifier? lst))

; Defining tag keys requires you to specify a target tag
; for each respective key. For example, you might want to
; generate bindings for "exclam" to tag 1: ("exclam" . 1).
; The first value in the pair must be a valid XKB key and the
; second value must be a number that is within the bounds of
; the defined tags, i.e. 1-<number of tags>.
(define (list-of-tag-key-pairs? lst)
  (every
    (lambda
      (pair)
      (and (xkb-key? (car pair)) (number? (cdr pair))))
    lst))
