#!/usr/bin/env guile
!#
;;; Basic UI Example using Terminal UI Framework
;;; Demonstrates core functionality and widget usage

(add-to-load-path (string-append (dirname (current-filename)) "/../src"))

(use-modules (terminal-ui core)
             (terminal-ui widgets)
             (ice-9 format))

(define main-ui
  (vbox
    (text "Welcome to Scheme Terminal UI Framework!" #:style 'bold #:align 'center)
    (text "")
    (hbox
      (button "File" #:action 'file-menu)
      (button "Edit" #:action 'edit-menu)
      (button "View" #:action 'view-menu))
    (text "")
    (text "This is a demonstration of the basic widget system." #:style 'normal)
    (text "Current features:")
    (text "  ✓ Text widgets with styling options")
    (text "  ✓ Button widgets with actions")
    (text "  ✓ Layout containers (vbox, hbox)")
    (text "  ✓ Basic application state management")
    (text "")
    (text "Framework version: " #:style 'italic)))

(define (main)
  (format #t "~%=== Basic Terminal UI Example ===~%~%")
  (run-app main-ui)
  (format #t "~%=== Example completed ===~%"))

;; Run the example
(main)