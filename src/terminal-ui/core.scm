;;; terminal-ui/core.scm --- Core functionality for Terminal UI Framework
;;; Copyright (C) 2025 aygp-dr

;;; This library is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Lesser General Public
;;; License as published by the Free Software Foundation; either
;;; version 3 of the License, or (at your option) any later version.

(define-module (terminal-ui core)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (version
            run-app
            render-ui
            make-app-state
            update-state))

;;; Version information
(define version "0.1.0")

;;; Basic application state structure
(define (make-app-state . initial-values)
  "Create a new application state with optional initial values."
  (let ((state (make-hash-table)))
    (for-each (lambda (pair)
                (hash-set! state (car pair) (cdr pair)))
              (list->pairs initial-values))
    state))

(define (list->pairs lst)
  "Convert a flat list to pairs for state initialization."
  (if (< (length lst) 2)
      '()
      (cons (cons (car lst) (cadr lst))
            (list->pairs (cddr lst)))))

;;; State management
(define (update-state state . updates)
  "Update application state with new values."
  (let ((new-state (make-hash-table)))
    ;; Copy existing state
    (hash-for-each (lambda (key value)
                     (hash-set! new-state key value))
                   state)
    ;; Apply updates
    (for-each (lambda (pair)
                (hash-set! new-state (car pair) (cdr pair)))
              (list->pairs updates))
    new-state))

;;; Basic UI rendering (placeholder)
(define (render-ui ui-spec)
  "Render a UI specification to the terminal."
  (match ui-spec
    ;; Handle text with keyword arguments
    (('text content . args)
     (let ((style (or (and (memq #:style args) (cadr (memq #:style args))) 'normal))
           (align (or (and (memq #:align args) (cadr (memq #:align args))) 'left))
           (color (and (memq #:color args) (cadr (memq #:color args)))))
       (display content)
       (newline)))
    
    ;; Handle button with keyword arguments
    (('button label . args)
     (let ((action (and (memq #:action args) (cadr (memq #:action args))))
           (enabled (or (and (memq #:enabled args) (cadr (memq #:enabled args))) #t)))
       (format #t "[~a]" label)))
    
    ;; Handle layout containers
    (('vbox . children)
     (for-each render-ui children))
    
    (('hbox . children)
     (for-each (lambda (child)
                 (render-ui child)
                 (display " "))
               children)
     (newline))
    
    ;; Handle other widgets
    (('textbox content . args)
     (display content)
     (newline))
    
    (('listbox items . args)
     (for-each (lambda (item)
                 (format #t "• ~a~%" item))
               items))
    
    (other
     (format #t "Unknown UI element: ~a~%" other))))

;;; Basic application runner
(define (run-app ui-spec . options)
  "Run a terminal UI application."
  (format #t "Starting Scheme Terminal UI Framework v~a~%" version)
  (render-ui ui-spec)
  (format #t "Application completed.~%"))