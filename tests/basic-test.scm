#!/usr/bin/env guile
!#
;;; Basic functionality tests for Terminal UI Framework

(add-to-load-path (string-append (dirname (current-filename)) "/../src"))

(use-modules (terminal-ui core)
             (terminal-ui widgets)
             (ice-9 format)
             (srfi srfi-64)) ; Simple test framework

(test-begin "terminal-ui-basic")

;; Test version
(test-equal "version-check" "0.1.0" version)

;; Test state management
(let ((state (make-app-state 'key1 'value1 'key2 'value2)))
  (test-assert "state-creation" (hash-table? state))
  
  (let ((updated-state (update-state state 'key1 'new-value 'key3 'value3)))
    (test-assert "state-update" (hash-table? updated-state))
    (test-equal "state-value-updated" 'new-value (hash-ref updated-state 'key1))
    (test-equal "state-value-preserved" 'value2 (hash-ref updated-state 'key2))
    (test-equal "state-value-added" 'value3 (hash-ref updated-state 'key3))))

;; Test widget creation
(let ((text-widget (text "Hello World" #:style 'bold #:align 'center)))
  (test-assert "text-widget-creation" (pair? text-widget))
  (test-equal "text-widget-type" 'text (car text-widget)))

(let ((button-widget (button "Click Me" #:action 'test-action)))
  (test-assert "button-widget-creation" (pair? button-widget))
  (test-equal "button-widget-type" 'button (car button-widget)))

;; Test layout containers
(let ((vbox-widget (vbox (text "Item 1") (text "Item 2"))))
  (test-assert "vbox-creation" (pair? vbox-widget))
  (test-equal "vbox-type" 'vbox (car vbox-widget)))

(let ((hbox-widget (hbox (button "A") (button "B"))))
  (test-assert "hbox-creation" (pair? hbox-widget))
  (test-equal "hbox-type" 'hbox (car hbox-widget)))

(test-end "terminal-ui-basic")

(format #t "~%=== Basic tests completed ===~%")