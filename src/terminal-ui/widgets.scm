;;; terminal-ui/widgets.scm --- Widget library for Terminal UI Framework
;;; Copyright (C) 2025 aygp-dr

;;; This library is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Lesser General Public
;;; License as published by the Free Software Foundation; either
;;; version 3 of the License, or (at your option) any later version.

(define-module (terminal-ui widgets)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (text
            button
            vbox
            hbox
            textbox
            listbox))

;;; Basic text widget
(define* (text content #:key (style 'normal) (align 'left) (color #f))
  "Create a text widget with optional styling."
  `(text ,content #:style ,style #:align ,align #:color ,color))

;;; Button widget
(define* (button label #:key (action #f) (enabled #t) (style 'normal))
  "Create a button widget."
  `(button ,label #:action ,action #:enabled ,enabled #:style ,style))

;;; Vertical box layout
(define (vbox . children)
  "Create a vertical box layout container."
  `(vbox ,@children))

;;; Horizontal box layout
(define (hbox . children)
  "Create a horizontal box layout container."
  `(hbox ,@children))

;;; Text input widget
(define* (textbox content #:key (editable #f) (multiline #f) (on-change #f))
  "Create a text input widget."
  `(textbox ,content #:editable ,editable #:multiline ,multiline #:on-change ,on-change))

;;; List widget
(define* (listbox items #:key (on-select #f) (multiple-selection #f))
  "Create a list widget."
  `(listbox ,items #:on-select ,on-select #:multiple-selection ,multiple-selection))