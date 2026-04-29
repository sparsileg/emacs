;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; position at startup
(setq initial-frame-alist '((width . 120) (height . 60 ) (top . 2) (left . 650)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; uniquify allows to have for instance "Makefile|proj" and
; "Makefile|otherProj" as buffer name instead of "Makefile" and
; "Makefile<2>", and it is activated only if there are multiple files
; with the same name!

;; uniquify!
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(savehist-mode 1)
;(require 'undo-tree)

;; this is the old way of doing things
;(global-hl-line-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tj-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (message "Buffer is set to read-only because it is large. Undo also disabled.")))

(add-hook 'find-file-hooks 'tj-find-file-check-make-large-file-read-only-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; without annoying startup msg
(setq inhibit-startup-message t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; ask if end a file with a newline
(setq require-final-newline 'query)

;; move by physical line (separated by \n), rather than visual line
(setq line-move-visual nil)

;; This tells emacs to show the column number in each modeline.
(column-number-mode 1)

;; save desktop periodically and load the last desktop up at start
;; confirm exiting emacs
;; (desktop-save-mode 1)
;; (setq confirm-kill-emacs 'y-or-n-p)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; one line at a time
(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)       ; scroll window under mouse
(setq scroll-step 1)                     ; one line at a time via cursor
(setq scroll-margin 5)                   ; keep cursor away from window edges
(setq scroll-conservatively 101)         ; prevent sudden jumps while scrolling
(setq scroll-preserve-screen-position t) ; maintain screen position when paging

;;; from snarged.org/why_i_dont_run_shells_inside_emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist '(("" . "~/.emacs.d/backup")))
 '(bookmark-save-flag 1)
 '(calendar-mark-diary-entries-flag t)
 '(calendar-mark-holidays-flag t)
 '(calendar-today-marker 'calendar-today-face)
 '(calendar-today-visible-hook '(calendar-mark-today))
 '(column-number-mode t)
 '(comint-completion-addsuffix t)
 '(comint-completion-autolist t)
 '(comint-input-ignoredups t)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(comint-scroll-to-bottom-on-output t)
 '(completion-auto-help 'lazy)
 '(display-time-mode t)
 '(fill-column 75)
 '(icomplete-mode t)
 '(ido-mode t nil (ido))
 '(indent-tabs-mode nil)
 '(package-selected-packages
   '(bm minimap undo-tree json-reformat company company-web markdown-mode markdown-preview-mode rust-mode
             svelte-mode typescript-mode yaml-mode))
 '(scroll-bar ((t (:background "Dark slate gray"))))
 '(setq indent-tabs-mode)
 '(setq-default show-trailing-whitespace t)
 '(show-paren-mode t)
 '(show-paren-style 'expression)
 '(size-indication-mode t)
 '(tab-width 4)
 '(today-visible-calendar-hook '(calendar-mark-today)))

;;; install all package in the package-selected-packages variable
;;; M-x package-install-selected-packages

; '(minimap-always-recenter t)
; '(minimap-mode t)
; '(minimap-window-location (quote right))

;;; from snarged.org/why_i_dont_run_shells_inside_emacs


;;; completion-auto-help values:
;;;     nil: never show completion buffer
;;;    lazy: show completion buffer after second <TAB>
;;;       t: display completion buffer whenever completion is requested but cannot be done
;;;
;;; use C-h v to see values of variables

; interpret and use ansi color codes in shell output windows
(ansi-color-for-comint-mode-on)

; make completion buffers disappear after 3 seconds.
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 3 nil
    (lambda () (delete-windows-on "*Completions*")))))

;; line numbers on left
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-grow-only nil)


;; displays time in modeline
(display-time)

;; inserts a horizontal line separator
(fset 'hline
   "\C-a#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#")

(defun cls ()
  "Clears a screen - typically used in a shell buffer"
  (interactive)
  (erase-buffer)
  )


;; inserts the python __future__ import options
(fset 'future_import
   "\C-afrom __future__ import print_function, division, absolute_import, unicode_literals")

;;; **********************************************************************
;;; rebind keys

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

(global-set-key (kbd "M-g") 'goto-line)

;; ;; Enable position saving through shortcuts.
;; ;; Save current position with  Ctrl-x /
(global-set-key (kbd "C-x /") '(lambda () (interactive) (point-to-register ?1)))

;; ;; Move to saved position with C-x j
(global-set-key (kbd "C-x j") '(lambda () (interactive) (jump-to-register-here ?1)))

;;; bind to C-c r
(global-set-key (kbd "C-c r") 'rename-file-and-buffer)

;;; **********************************************************************

;;; syntax highlighting
;;; toggle: M-x global-font-lock-mode
(global-font-lock-mode t)

(defun jump-to-register-other (reg)
  (other-window 1)
  (jump-to-register reg))

(defun jump-to-register-here (reg)
  (jump-to-register reg))

;;; set "cipher-algo AES256" in .gnupg/gpg.conf to set default (rather than 3DES)
(require 'epa-file)
(epa-file-enable)

;(require 'remember)
;(setq remember-annotation-functions `(org-remember-annotation))
;(setq remember-handler-functions `(org-remember-handler))
;(setq remember-mode-hook `org-remember-apply-template)

; line numbering
(require 'linum)

;;; Turn on Auto Fill mode automatically in various modes
(add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill)
(add-hook 'ReST-mode-hook 'turn-on-auto-fill)
(add-hook 'ReST-mode-hook 'refill-mode)
(add-hook 'shell-script-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; python script stuff
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'flymake-mode)

(add-hook 'python-mode-hook
		  (lambda ()
			(linum-on)
			))


;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "epylint" (list local-file))))

;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pylint-init)))


(set-face-foreground 'font-lock-comment-face "blue")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; shell script stuff
(add-hook 'sh-mode-hook
		  (lambda ()
			(linum-on)
			))

;;; only for shell mode, suppress the "Active processes exist ... exit anyway?"
;;; query. NOTE that this command must be included BEFORE the shell is
;;; started automatically. don't know why
;(add-hook 'shell-mode-hook
;          (lambda ()
;            (process-kill-without-query (get-buffer-process (current-buffer)))))

;;;
(add-hook 'java-mode-hook
		  (lambda ()
			(linum-on)
			))

(add-hook 'emacs-lisp-mode-hook
		  (lambda ()
			(linum-on)
			))

(add-hook 'php-mode-hook
		  (lambda ()
			(linum-on)
			))

(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
(add-hook 'svelte-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))

(add-hook 'rust-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))
(add-hook 'rust-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-hook 'typescript-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))

;;(setq linum-format "%4d \u2502")

;;; set modes for various types of files
(setq auto-mode-alist (cons '("README" . text-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("readme" . text-mode) auto-mode-alist))

;;; Handle .gz files. on by default, but "just to make sure"
(auto-compression-mode t)

;;; renames a file and buffer while it is being visited
(defun rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
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

;;; start shell automatically and rename it
(shell "shell-1")
(defun init-at-startup()
  (execute-kbd-macro
   [?\C-x ?b ?s ?h ?e ?l ?l ?- ?1 return ?\C-x ?1]))
(init-at-startup)


;;; delete trailing whitespace on save
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BETA TEST STUFF

(put 'narrow-to-region 'disabled nil)   ; Enable region narrowing & widening.

;;; Preserve the owner and group of the file you are editing (this is
;;; especially important if you edit files as root).
(setq backup-by-copying-when-mismatch t)

;;; Make cut/copy/paste set/use the X CLIPBOARD in preference to the X
;;; PRIMARY. Unbreaks cut and paste between Emacs and well-behaved
;;; applications like Mozilla, KDE, and GNOME, but breaks cut and
;;; paste between Emacs and old applications like terminals.
(setq x-select-enable-clipboard t)

(set-face-foreground 'highlight "black")
(set-face-foreground 'secondary-selection "black")
(set-face-foreground 'highlight "black")

;; Here are some color preferences.
(setq default-frame-alist
      (append default-frame-alist
              '((foreground-color . "black")
                (background-color . "cornsilk")
                (cursor-color . "blue"))))

(set-face-foreground 'bold "yellow")
(set-face-background 'bold "grey40")

(set-face-foreground 'bold-italic "yellow green")
(set-face-foreground 'italic "yellow3")

(set-face-foreground 'region "white")
(set-face-background 'region "blue")


;;; M-x list-faces-display
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "cornsilk" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight bold :height 92 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(calendar-today ((t (:weight ultra-bold))))
 '(diary ((((min-colors 88) (class color) (background light)) (:background "black" :foreground "white"))))
 '(flymake-error ((t (:inherit error :inverse-video t))))
 '(flymake-warning ((t (:inherit warning :inverse-video t)))))

;;; wrappers to enable
;(require 'vc-svn17)
;;;(setq vc-svn-diff-switches '("-x --ignore-eol-style" "-x -w"))
;;;(setq vc-diff-switches '("--normal" "-bB"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; from https://github.com/DarwinAwardWinner/dotemacs/blob/master/site-lisp/settings/ido-settings.el
(require 'ido)
(load "ido-other-window" 'noerror)
(when (load "ido-yes-or-no" 'noerror)
  (ido-yes-or-no-mode 1))

(defadvice ido-complete-space (around handle-require-match activate)
  "If require-match is nil, always insert space."
  (if (bound-and-true-p require-match)
      (ido-complete)
    (insert " ")))

(eval-after-load "mic-paren"
  '(defadvice mic-paren-highlight (around disable-inside-ido activate)
     "Disable mic-paren highlighting in ido"
     (unless (ido-active)
       ad-do-it)))

(provide 'ido-settings)

(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)

;;; add a Filesets menu to  menu bar
(filesets-init)

;;;

(put 'downcase-region 'disabled nil)

;;; reload buffers automatically if they change
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)


;;; Stefan Monnier <foo at acm.org>. It is the opposite of
;;; fill-paragraph. Takes a multi-line paragraph and makes
;;; it into a single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))


;;; calendar and diary stuff
;;;(diary)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)

;;; quick function folding
(defun toggle-selective-display ()
  (interactive)
  (set-selective-display (if selective-display nil 1)))

;;; increment folding function
(defun increment-selective-display ()
  (interactive)
  (let ((column (if selective-display
                    (+ selective-display 4) 4)))
    (if (> column 16)
        (set-selective-display nil)
      (set-selective-display column))))

;;; hide all comments
;;; Hide all top level blocks, if they are comments, displaying only
;;; the first line.

(defun hs-hide-all-comments ()
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
             ;; found a comment, probably
             (let ((c-reg (hs-inside-comment-p)))
               (when (and c-reg (car c-reg))
                 (if (> (count-lines (car c-reg) (nth 1 c-reg)) 1)
                     (hs-hide-block-at-point t c-reg)
                   (goto-char (nth 1 c-reg))))))
         (progress-reporter-update spew (point)))
       (progress-reporter-done spew)))
   (beginning-of-line)
   (run-hooks 'hs-hide-hook)))

;;; make all files with a shebang in them, executable when saved
(add-hook
 'after-save-hook
 #'(lambda ()
     (and
      (save-excursion
        (save-restriction
          (widen)
          (goto-char (point-min))
          (save-match-data
            (looking-at "^#!"))))
      (not (file-executable-p buffer-file-name))
      (shell-command (concat "chmod a+x "
                             (shell-quote-argument
                              buffer-file-name)))
      (message
       (concat "Saves as script: " buffer-file-name)))))


;;; do a backup after a save on any file that begins with a .TODO
(add-hook
 'after-save-hook
 #'(lambda ()
(and
 (setq thebuff (abbreviate-file-name (shell-quote-argument buffer-file-name)))
 (setq bn (file-name-nondirectory thebuff))
 (if (string-match "^\\.TODO" bn)
     (and
      (setq newfile (concat "dot-" (substring bn 1 (length bn))))
      (setq bu (concat "xmidas@smaug:/backups/developers/sgb/" newfile))
      (setq bucmd (concat "scp " thebuff " " bu))
      (shell-command bucmd)
      (message (concat "Executed : " bucmd)))))))

;;; shortcut to reformatting a paragraph
(defun refill-paragraph ()
  (interactive)
  (unfill-paragraph)
  (fill-paragraph)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; use pure emacs json reformatter

;(require 'json-reformat)

(put 'scroll-left 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; visible bookmarks

;(require 'bm)

;;(global-set-key (kbd "<C-f2>") 'bm-toggle)
;;(global-set-key (kbd "<f2>") 'bm-next)
;;(global-set-key (kbd "<S-f2>") 'bm-previous)

;;; click on fringe to toggle bookmarks and use mouse wheel to move between
;;; them
;(global-set-key (kbd "<left-fringe> <mouse-5>") 'bm-next-mouse)
;(global-set-key (kbd "<left-fringe> <mouse-4>") 'bm-previous-mouse)
;(global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)


;;; make bookmarks persistent as default
;(setq-default bm-buffer-persistence t)

;;; load the repository from file on start up
;(add-hook 'after-init-hook 'bm-repository-load)

;;; restore bookmarks when on file find
;(add-hook 'find-file-hook 'bm-buffer-restore)

;;; save bookmark data on killing buffer
;(add-hook 'kill-buffer-hook 'bm-buffer-save)

;;; save repository to file on exit
;(add-hook 'kill-emacs-hook '(lambda nil
;                              (bm-buffer-save-all)
;                              (bm-repository-save)))

;;; cycle through bookmarks in ALL open buffers
;(setq bm-cycle-all-buffers t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; minimap mode stuff

;(require 'minimap)

;(setq minimap-major-modes '(prog-mode rst-mode text-mode Shell-script))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MELPA package repository
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; performance tweaks
(setq gc-cons-threshold 100000000) ;; 100 MB before GC
(setq read-process-output-max (* 1024 1024)) ;; 1 MB
(setq large-file-warning-threshold nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/markdown-mode")
(require 'markdown-mode)

(require 'flyspell)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)  ; spell check comments/strings only


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; keyboard macros

;; insert tooltips into element
(fset 'tt
   (kmacro-lambda-form [?c ?l ?a ?s ?s ?= ?\" ?t ?o ?o ?l ?t ?i ?p ?- ?h ?o ?s ?t ?\" ?  ?d ?a ?t ?a ?- ?t ?o ?o ?l ?t ?i ?p ?- ?k ?e ?y ?= ?\" ?\" ?\C-b] 0 "%d"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
