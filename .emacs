;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ~/.emacs - Emacs Configuration
;; Organized for clarity and maintainability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PLATFORM-SPECIFIC SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Windows configuration
(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Consolas-11")
  (setenv "HOME" "C:/Users/stanb/OneDrive/stan/")
  (setq default-directory "C:/Users/stanb/OneDrive/stan/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE MANAGEMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install packages automatically if missing
(setq package-selected-packages
      '(markdown-mode
        rust-mode
        typescript-mode
        svelte-mode
        yaml-mode
        company              ; autocomplete
        company-web          ; web completion
        flyspell             ; spell checking
        lsp-mode             ; Language Server Protocol
        lsp-ui               ; LSP UI enhancements
        ))

;; Uncomment to auto-install missing packages on startup
;; (unless package-archive-contents (package-refresh-contents))
;; (package-install-selected-packages)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PERFORMANCE OPTIMIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq gc-cons-threshold 100000000)        ; 100 MB before GC
(setq read-process-output-max (* 1024 1024)) ; 1 MB for subprocess output
(setq large-file-warning-threshold nil)   ; Don't warn about large files

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI/UX SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Window geometry
(setq initial-frame-alist '((width . 120) (height . 60) (top . 2) (left . 650)))

;; Basic UI
(setq inhibit-startup-message t)          ; Skip startup screen
(column-number-mode 1)                    ; Show column numbers
(size-indication-mode t)                  ; Show file size
(display-time-mode t)                     ; Show time in modeline
(show-paren-mode t)                       ; Highlight matching parens
(setq show-paren-style 'expression)       ; Highlight entire expression
(global-hl-line-mode 1)                   ; Highlight current line
(global-auto-revert-mode 1)               ; Auto-reload changed files
(setq auto-revert-verbose nil)            ; Don't announce reverts

;; Line numbers (modern approach)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative) ; Relative line numbers
(setq display-line-numbers-grow-only nil)

;; Frame title shows buffer name and hostname
(setq frame-title-format (concat "%b - emacs@" (system-name)))

;; Enable narrow/wide region
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EDITING BEHAVIOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Indentation
(setq-default indent-tabs-mode nil)       ; Use spaces, not tabs
(setq-default tab-width 4)                ; Tab width = 4 spaces
(setq fill-column 75)                     ; Default fill column

;; Selection and marking
(setq transient-mark-mode t)              ; Visual feedback on selections

;; Newlines
(setq require-final-newline 'query)       ; Ask before adding final newline

;; Scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; One line at a time
(setq mouse-wheel-progressive-speed nil)  ; Don't accelerate
(setq mouse-wheel-follow-mouse 't)        ; Scroll window under mouse
(setq scroll-step 1)                      ; Smooth scrolling
(setq scroll-margin 5)                    ; Keep cursor away from edges
(setq scroll-conservatively 101)          ; Prevent jumps
(setq scroll-preserve-screen-position t)  ; Maintain position when paging
(setq line-move-visual nil)               ; Move by logical lines

;; Completion
(setq completion-auto-help 'lazy)         ; Show completions after second TAB
(icomplete-mode t)                        ; Enhanced minibuffer completion

;; Auto-delete trailing whitespace on save
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BACKUP AND HISTORY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
(setq backup-by-copying-when-mismatch t)  ; Preserve file ownership
(savehist-mode 1)                         ; Save minibuffer history
(setq bookmark-save-flag 1)               ; Save bookmarks on change

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BUFFER MANAGEMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uniquify: Better buffer names for duplicate filenames
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

;; Large file handling - make read-only and disable undo
(defun tj-find-file-check-make-large-file-read-only-hook ()
  "If a file is over 1MB, make buffer read-only and disable undo."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (message "Large file: buffer is read-only, undo disabled.")))

(add-hook 'find-file-hooks 'tj-find-file-check-make-large-file-read-only-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IDO MODE (Interactive Do)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)         ; Fuzzy matching
(setq ido-create-new-buffer 'always)      ; Don't confirm new buffers

(load "ido-other-window" 'noerror)
(when (load "ido-yes-or-no" 'noerror)
  (ido-yes-or-no-mode 1))

(defadvice ido-complete-space (around handle-require-match activate)
  "If require-match is nil, always insert space."
  (if (bound-and-true-p require-match)
      (ido-complete)
    (insert " ")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROGRAMMING MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax highlighting
(global-font-lock-mode t)

;; Auto-fill in text/code modes
(add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'shell-script-mode-hook 'turn-on-auto-fill)

;; Spell checking in programming modes (comments/strings only)
(require 'flyspell)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; Python
(add-hook 'python-mode-hook 'hs-minor-mode)  ; Code folding
(add-hook 'python-mode-hook 'flymake-mode)   ; On-the-fly syntax checking

;; Rust
(add-hook 'rust-mode-hook 'display-line-numbers-mode)
;; Uncomment for LSP support:
;; (add-hook 'rust-mode-hook 'lsp)

;; TypeScript
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-hook 'typescript-mode-hook 'display-line-numbers-mode)
;; Uncomment for LSP support:
;; (add-hook 'typescript-mode-hook 'lsp)

;; Svelte
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
(add-hook 'svelte-mode-hook 'display-line-numbers-mode)
;; Uncomment for LSP support:
;; (add-hook 'svelte-mode-hook 'lsp)

;; File type associations
(add-to-list 'auto-mode-alist '("README\\'" . text-mode))
(add-to-list 'auto-mode-alist '("readme\\'" . text-mode))

;; Handle compressed files
(auto-compression-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SHELL AND TERMINAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ANSI colors in shell output
(ansi-color-for-comint-mode-on)

;; Shell completion settings
(setq comint-completion-addsuffix t)
(setq comint-completion-autolist t)
(setq comint-input-ignoredups t)
(setq comint-scroll-show-maximum-output t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)

;; Auto-hide completion buffers after 3 seconds
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 3 nil
    (lambda () (delete-windows-on "*Completions*")))))

;; Start shell on startup
(shell "shell-1")
(defun init-at-startup()
  (execute-kbd-macro
   [?\C-x ?b ?s ?h ?e ?l ?l ?- ?1 return ?\C-x ?1]))
(init-at-startup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUTOCOMPLETE (Company Mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uncomment to enable company-mode globally
;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENCRYPTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'epa-file)
(epa-file-enable)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CALENDAR AND DIARY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq calendar-mark-diary-entries-flag t)
(setq calendar-mark-holidays-flag t)
(setq calendar-today-marker 'calendar-today-face)
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FILESETS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(filesets-init)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEY BINDINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Function keys
(global-set-key [f1] 'toggle-selective-display)
(global-set-key [f2] 'increment-selective-display)
(global-set-key [f3] 'hs-hide-all-comments)
(global-set-key [f4] 'hs-show-all)
(global-set-key [f5] 'goto-line)
(global-set-key [f6] 'flymake-goto-prev-error)
(global-set-key [f7] 'flymake-goto-next-error)
(global-set-key [f8] 'flymake-display-err-menu-for-current-line)
(global-set-key [f9] (read-kbd-macro "C-u M-."))
(global-set-key [f11] 'hline)
(global-set-key [f12] 'undo)

;; Custom bindings
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-c r") 'rename-file-and-buffer)

;; Position markers
(global-set-key (kbd "C-x /") '(lambda () (interactive) (point-to-register ?1)))
(global-set-key (kbd "C-x j") '(lambda () (interactive) (jump-to-register ?1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cls ()
  "Clear shell buffer."
  (interactive)
  (erase-buffer))

(defun rename-file-and-buffer ()
  "Rename current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (message "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)))))))

(defun unfill-paragraph ()
  "Convert multi-line paragraph to single line."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun refill-paragraph ()
  "Unfill then refill paragraph."
  (interactive)
  (unfill-paragraph)
  (fill-paragraph))

(defun toggle-selective-display ()
  "Toggle code folding."
  (interactive)
  (set-selective-display (if selective-display nil 1)))

(defun increment-selective-display ()
  "Increment folding level by 4 spaces."
  (interactive)
  (let ((column (if selective-display
                    (+ selective-display 4) 4)))
    (if (> column 16)
        (set-selective-display nil)
      (set-selective-display column))))

(defun hs-hide-all-comments ()
  "Hide all comment blocks."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (unless hs-allow-nesting
       (hs-discard-overlays (point-min) (point-max)))
     (goto-char (point-min))
     (let ((spew (make-progress-reporter "Hiding all comment blocks ..."
                                         (point-min) (point-max)))
           (re (concat "\\(" hs-c-start-regexp "\\)")))
       (while (re-search-forward re (point-max) t)
         (if (match-beginning 1)
             (let ((c-reg (hs-inside-comment-p)))
               (when (and c-reg (car c-reg))
                 (if (> (count-lines (car c-reg) (nth 1 c-reg)) 1)
                     (hs-hide-block-at-point t c-reg)
                   (goto-char (nth 1 c-reg))))))
         (progress-reporter-update spew (point)))
       (progress-reporter-done spew)))
   (beginning-of-line)
   (run-hooks 'hs-hide-hook)))

(defun jump-to-register-here (reg)
  "Jump to register in current window."
  (jump-to-register reg))

(defun jump-to-register-other (reg)
  "Jump to register in other window."
  (other-window 1)
  (jump-to-register reg))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEYBOARD MACROS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Insert horizontal line
(fset 'hline
      "\C-a#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#")

;; Insert Python future imports
(fset 'future_import
      "\C-afrom __future__ import print_function, division, absolute_import, unicode_literals")

;; Insert tooltip attributes
(fset 'tt
      (kmacro-lambda-form [?c ?l ?a ?s ?s ?= ?\" ?t ?o ?o ?l ?t ?i ?p ?- ?h ?o ?s ?t ?\"
                           ?  ?d ?a ?t ?a ?- ?t ?o ?o ?l ?t ?i ?p ?- ?k ?e ?y ?= ?\" ?\" ?\C-b]
                          0 "%d"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUTO-SAVE HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make scripts executable on save
(add-hook 'after-save-hook
  #'(lambda ()
      (and (save-excursion
             (save-restriction
               (widen)
               (goto-char (point-min))
               (save-match-data
                 (looking-at "^#!"))))
           (not (file-executable-p buffer-file-name))
           (shell-command (concat "chmod a+x "
                                  (shell-quote-argument buffer-file-name)))
           (message (concat "Saved as executable script: " buffer-file-name)))))

;; Backup .TODO files to remote server
;; Note: Customize server/path or remove if not needed
(add-hook 'after-save-hook
  #'(lambda ()
      (let* ((thebuff (abbreviate-file-name (shell-quote-argument buffer-file-name)))
             (bn (file-name-nondirectory thebuff)))
        (when (string-match "^\\.TODO" bn)
          (let* ((newfile (concat "dot-" (substring bn 1)))
                 (bu (concat "xmidas@smaug:/backups/developers/sgb/" newfile))
                 (bucmd (concat "scp " thebuff " " bu)))
            (shell-command bucmd)
            (message (concat "Backed up: " bucmd)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COLOR THEME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Clipboard integration
(setq x-select-enable-clipboard t)

;; Basic colors
(setq default-frame-alist
      (append default-frame-alist
              '((foreground-color . "black")
                (background-color . "cornsilk")
                (cursor-color . "blue"))))

(set-face-foreground 'font-lock-comment-face "blue")
(set-face-foreground 'highlight "black")
(set-face-foreground 'secondary-selection "black")
(set-face-foreground 'bold "yellow")
(set-face-background 'bold "grey40")
(set-face-foreground 'bold-italic "yellow green")
(set-face-foreground 'italic "yellow3")
(set-face-foreground 'region "white")
(set-face-background 'region "blue")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM-SET-VARIABLES (auto-generated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-switches "-u"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "cornsilk" :foreground "black"
                :inverse-video nil :box nil :strike-through nil :overline nil :underline nil
                :slant normal :weight bold :height 92 :width normal :foundry "unknown"
                :family "DejaVu Sans Mono"))))
 '(calendar-today ((t (:weight ultra-bold))))
 '(diary ((((min-colors 88) (class color) (background light))
          (:background "black" :foreground "white"))))
 '(flymake-error ((t (:inherit error :inverse-video t))))
 '(flymake-warning ((t (:inherit warning :inverse-video t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; END OF CONFIGURATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
