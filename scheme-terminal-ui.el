;;; scheme-terminal-ui.el --- Emacs configuration for Scheme Terminal UI development

;;; Commentary:
;; Emacs configuration for developing the Scheme Terminal UI framework
;; with support for Geiser, Guile 3, Org mode, TRAMP, and Paredit

;;; Code:

;; Package initialization
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Install required packages if not present
(defvar scheme-terminal-ui-packages
  '(geiser
    geiser-guile
    paredit
    rainbow-delimiters
    company
    flycheck
    org))

(dolist (pkg scheme-terminal-ui-packages)
  (unless (package-installed-p pkg)
    (package-refresh-contents)
    (package-install pkg)))

;; Project settings
(defvar scheme-terminal-ui-root
  (file-name-directory (or load-file-name buffer-file-name))
  "Root directory of the Scheme Terminal UI project.")

(defvar scheme-terminal-ui-name "scheme-terminal-ui"
  "Project name.")

;; Geiser configuration for Guile
(require 'geiser)
(require 'geiser-guile)
(setq geiser-guile-binary "guile3")
(setq geiser-active-implementations '(guile))
(setq geiser-default-implementation 'guile)
(setq geiser-repl-history-filename
      (expand-file-name ".geiser-history" scheme-terminal-ui-root))

;; Add project source directories to Guile load path
(setq geiser-guile-load-path
      (list (expand-file-name "src" scheme-terminal-ui-root)
            (expand-file-name "tests" scheme-terminal-ui-root)
            (expand-file-name "examples" scheme-terminal-ui-root)))

;; Paredit for structured editing
(require 'paredit)
(add-hook 'scheme-mode-hook #'paredit-mode)
(add-hook 'geiser-repl-mode-hook #'paredit-mode)

;; Rainbow delimiters for better readability
(require 'rainbow-delimiters)
(add-hook 'scheme-mode-hook #'rainbow-delimiters-mode)
(add-hook 'geiser-repl-mode-hook #'rainbow-delimiters-mode)

;; Company mode for completion
(require 'company)
(add-hook 'scheme-mode-hook #'company-mode)
(add-hook 'geiser-repl-mode-hook #'company-mode)
(setq company-idle-delay 0.3)
(setq company-minimum-prefix-length 2)

;; Flycheck for syntax checking
(require 'flycheck)
(add-hook 'scheme-mode-hook #'flycheck-mode)

;; Org mode configuration for documentation
(require 'org)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-edit-src-content-indentation 0)
(setq org-src-preserve-indentation t)

;; TRAMP configuration for remote development
(require 'tramp)
(setq tramp-default-method "ssh")
(setq tramp-verbose 2)

;; Project-specific key bindings
(defvar scheme-terminal-ui-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-l") 'geiser-load-file)
    (define-key map (kbd "C-c C-k") 'geiser-compile-current-buffer)
    (define-key map (kbd "C-c C-r") 'geiser-eval-region)
    (define-key map (kbd "C-c C-e") 'geiser-eval-last-sexp)
    (define-key map (kbd "C-c C-d") 'geiser-doc-symbol-at-point)
    (define-key map (kbd "C-c C-z") 'geiser-mode-switch-to-repl)
    (define-key map (kbd "C-c C-t") 'scheme-terminal-ui-run-tests)
    (define-key map (kbd "C-c C-x") 'scheme-terminal-ui-run-example)
    map)
  "Keymap for Scheme Terminal UI development.")

;; Custom functions
(defun scheme-terminal-ui-run-tests ()
  "Run the project test suite."
  (interactive)
  (let ((default-directory scheme-terminal-ui-root))
    (compile "make test")))

(defun scheme-terminal-ui-run-example ()
  "Run example programs."
  (interactive)
  (let ((default-directory scheme-terminal-ui-root))
    (compile "make run-examples")))

(defun scheme-terminal-ui-repl ()
  "Start a Geiser REPL for the project."
  (interactive)
  (let ((default-directory scheme-terminal-ui-root))
    (geiser 'guile)))

;; Define minor mode for project-specific features
(define-minor-mode scheme-terminal-ui-mode
  "Minor mode for Scheme Terminal UI development."
  :lighter " STU"
  :keymap scheme-terminal-ui-mode-map
  (when scheme-terminal-ui-mode
    (setq-local compile-command
                (format "cd %s && make" scheme-terminal-ui-root))))

;; Automatically enable the mode for project files
(defun scheme-terminal-ui-setup ()
  "Setup function for Scheme Terminal UI development."
  (when (and buffer-file-name
             (string-prefix-p scheme-terminal-ui-root buffer-file-name))
    (scheme-terminal-ui-mode 1)))

(add-hook 'scheme-mode-hook #'scheme-terminal-ui-setup)

;; Start Geiser REPL on load
(scheme-terminal-ui-repl)

;; Display welcome message
(message "Scheme Terminal UI development environment loaded!")
(message "Project root: %s" scheme-terminal-ui-root)
(message "Use C-c C-h to see available key bindings")

(provide 'scheme-terminal-ui)
;;; scheme-terminal-ui.el ends here