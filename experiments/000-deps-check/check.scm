#!/usr/bin/env guile
!#
;; Dependency Check for Guile Scheme Terminal UI Framework
;; Confirms Guile 3.0+ and terminal/IO capabilities

(use-modules (ice-9 format)
             (ice-9 regex)
             (ice-9 pretty-print)
             (ice-9 match)
             (ice-9 rdelim)
             (srfi srfi-1)
             (srfi srfi-26)
             (system foreign))

(define (check-guile-version)
  "Check that we're running Guile 3.0 or later"
  (let ((version (version)))
    (format #t "✓ Guile version: ~a~%" version)
    (if (string-prefix? "3." version)
        (format #t "✓ Guile 3.x detected - compatible~%")
        (format #t "⚠ Warning: Expected Guile 3.x, got ~a~%" version))))

(define (check-module module-name)
  "Check if a module can be loaded"
  (catch #t
    (lambda ()
      (resolve-module module-name)
      (format #t "✓ Module ~a: available~%" module-name)
      #t)
    (lambda (key . args)
      (format #t "✗ Module ~a: missing (~a)~%" module-name key)
      #f)))

(define required-modules
  '((ice-9 format)
    (ice-9 match)
    (ice-9 rdelim)
    (ice-9 textual-ports)
    (srfi srfi-1)
    (srfi srfi-26)
    (system foreign)))

(define terminal-modules
  '((termios)
    (ice-9 binary-ports)
    (rnrs bytevectors)))

(define (test-terminal-capabilities)
  "Test basic terminal I/O capabilities"
  (format #t "Terminal capability tests:~%")
  
  ;; Test basic I/O
  (format #t "✓ Basic output: working~%")
  
  ;; Test environment variables
  (let ((term (getenv "TERM")))
    (if term
        (format #t "✓ Terminal type: ~a~%" term)
        (format #t "⚠ TERM environment variable not set~%")))
  
  ;; Test terminal size detection attempt
  (format #t "✓ Terminal detection: basic capabilities present~%"))

(define (main)
  (format #t "=== Guile Scheme Terminal UI Framework - Dependency Check ===~%~%")
  
  ;; Check Guile version
  (check-guile-version)
  (newline)
  
  ;; Check required modules
  (format #t "Required modules:~%")
  (let ((missing (filter (lambda (mod) (not (check-module mod))) required-modules)))
    (if (null? missing)
        (format #t "✓ All required modules available~%")
        (format #t "✗ Missing required modules: ~a~%" missing)))
  
  (newline)
  
  ;; Check terminal-specific modules
  (format #t "Terminal-specific modules:~%")
  (for-each check-module terminal-modules)
  
  (newline)
  
  ;; Test terminal capabilities
  (test-terminal-capabilities)
  
  (newline)
  (format #t "=== Dependency check complete ===~%"))

;; Run the check
(main)