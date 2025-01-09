;;; aider-code-read.el --- Code reading enhancement for aider.el -*- lexical-binding: t; -*-

;; Author: Kang Tu <tninja@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1") (aider "0.2.0"))
;; Keywords: convenience, tools
;; URL: https://github.com/tninja/aider-code-read.el

;;; Commentary:
;; This package enhances aider.el with code reading techniques from
;; "Code Reading: The Open Source Perspective" by Diomidis Spinellis.

;;; Code:

(require 'aider)
(require 'transient)

(defun aider-analyze-code-unit ()
  "Analyze current function or region using bottom-up reading technique.
Follows Spinellis' method of understanding individual components first."
  (interactive)
  (if (region-active-p)
      (let ((region-text (buffer-substring-no-properties (region-beginning) (region-end))))
        (aider--send-command 
         (format "/ask Analyze this code unit using bottom-up reading:
1. Identify basic operations and control structures
2. Explain data structures used
3. Document function calls and their purposes
4. Summarize the overall logic

Code:
%s" region-text) t))
    (if-let ((function-name (which-function)))
        (aider--send-command 
         (format "/ask Analyze function '%s' using bottom-up reading approach. 
Explain its basic operations, data structures, and control flow." function-name) t)
      (message "No function or region selected."))))

(defun aider-analyze-program-structure ()
  "Analyze code structure using top-down reading technique from Spinellis' book."
  (interactive)
  (aider-add-current-file)
  (aider--send-command 
   "/architect Please analyze this code using top-down reading:
1. Identify main components and their relationships
2. Explain the program's architecture
3. Document key interfaces between components
4. Highlight important design patterns used
5. Map the control flow between major components" t))

(defun aider-analyze-dependencies ()
  "Analyze code dependencies following Spinellis' cross-reference technique."
  (interactive)
  (if-let ((function-name (which-function)))
      (progn
        (aider-add-current-file)
        (aider--send-command 
         (format "/ask For function '%s', please:
1. List all functions it calls
2. List all functions that call it
3. Identify key data dependencies
4. Map external library dependencies
5. Note any global state interactions" function-name) t))
    (message "No function at point.")))

(defun aider-identify-patterns ()
  "Identify common patterns in code following Spinellis' pattern recognition approach."
  (interactive)
  (aider-add-current-file)
  (aider--send-command 
   "/ask Please identify and explain:
1. Common design patterns used
2. Algorithmic patterns
3. Error handling patterns
4. Data structure patterns
5. Any anti-patterns that should be noted" t))

;; Check if "Code Reading" section exists in the menu
(defun aider-code-read--has-section-p ()
  "Check if Code Reading section already exists in aider-transient-menu."
  (let ((layout (get 'aider-transient-menu 'transient--layout)))
    (cl-some (lambda (item)
               (and (listp item)
                    (equal (car item) "Code Reading")))
             layout)))

;; Add the Code Reading section if it doesn't exist
(with-eval-after-load 'aider
  (unless (aider-code-read--has-section-p)
    (transient-append-suffix 'aider-transient-menu '(0)
      '["Code Reading"
        ("R" "Bottom-up Analysis" aider-analyze-code-unit)
        ("S" "Top-down Analysis" aider-analyze-program-structure)
        ("D" "Dependency Analysis" aider-analyze-dependencies)
        ("P" "Pattern Recognition" aider-identify-patterns)])))

(provide 'aider-code-read)

;;; aider-code-read.el ends here
