;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ~/.emacs - Emacs Configuration
;; Using use-package for better package management
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

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)  ; Auto-install packages if missing

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
(setq initial-frame-alist '((width . 120) (height . 100) (top . 5) (right . 5)))

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

;; Avy - jump to any location on your screen with 2 letters
;; Type C-c j then two characters → jump anywhere on screen
;; Way faster than searching or scrolling

(use-package avy
  :bind (("C-'" . avy-goto-line)
         ("C-c j" . avy-goto-char-2))
  :config
  ;; Customize avy appearance
  (set-face-attribute 'avy-lead-face nil
                      :foreground "#1a1a24"      ; Dark background color
                      :background "#e8a75a"      ; Bright orange (like your region)
                      :weight 'bold)

  (set-face-attribute 'avy-lead-face-0 nil
                      :foreground "#1a1a24"
                      :background "#61afef"      ; Bright blue
                      :weight 'bold)

  (set-face-attribute 'avy-lead-face-1 nil
                      :foreground "#1a1a24"
                      :background "#c678dd"      ; Purple
                      :weight 'bold)

  (set-face-attribute 'avy-lead-face-2 nil
                      :foreground "#1a1a24"
                      :background "#98c379"      ; Green
                      :weight 'bold))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BACKUP AND HISTORY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
(setq backup-by-copying t)                ; Don't clobber symlinks
(setq backup-by-copying-when-mismatch t)  ; Preserve file ownership
(setq delete-old-versions t)              ; Delete excess backups
(setq kept-new-versions 6)                ; Keep 6 newest versions
(setq kept-old-versions 2)                ; Keep 2 oldest versions
(setq version-control t)                  ; Use version numbers on backups
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

;; Disable IDO completion in shell buffers - use plain completion instead
(defun disable-ido-in-shell ()
  "Turn off IDO completion in shell/comint buffers."
  (setq-local ido-everywhere nil)
  (setq-local ido-enable-flex-matching nil)
  (setq-local completing-read-function 'completing-read-default))

(add-hook 'shell-mode-hook 'disable-ido-in-shell)
(add-hook 'eshell-mode-hook 'disable-ido-in-shell)
(add-hook 'comint-mode-hook 'disable-ido-in-shell)

(load "ido-other-window" 'noerror)
(when (load "ido-yes-or-no" 'noerror)
  (ido-yes-or-no-mode 1))

(defadvice ido-complete-space (around handle-require-match activate)
  "If require-match is nil, always insert space."
  (if (bound-and-true-p require-match)
      (ido-complete)
    (insert " ")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES (using use-package)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Which-key: Show available keybindings as you type
;; Shows a popup with all possible completions when you pause mid-command
;;
;; USAGE:
;;   Press C-x and wait a moment → see all C-x ... commands
;;   Press C-c and wait → see all C-c ... commands
;;   Press C-c p and wait → see all Projectile commands
;;
;; EXAMPLE:
;;   You remember the command starts with C-x but forget the rest?
;;   Press C-x, pause, and which-key shows: C-x g (magit), C-x b (buffers), etc.
;;
;; TIP: Invaluable for learning Emacs keybindings!
(use-package which-key
  :config
  (which-key-mode))

;; Projectile: Project management and navigation
;; Automatically detects projects (git repos, Cargo.toml, package.json, etc.)
;;
;; COMMON COMMANDS:
;;   C-c p f   - Find file in project (fuzzy search within project only)
;;   C-c p s g - Search (grep) across entire project for text
;;   C-c p p   - Switch to another project (remembers recent projects)
;;   C-c p b   - Switch to buffer in current project
;;   C-c p d   - Find directory in project
;;   C-c p c   - Run compile command for project
;;   C-c p k   - Kill all project buffers
;;   C-c p !   - Run shell command in project root
;;   C-c p R   - Replace text across entire project
;;
;; WORKFLOW EXAMPLE:
;;   1. Open any file in ~/Projects/Photyx/
;;   2. Projectile auto-detects it as a project
;;   3. Press C-c p f → type "logging" → instantly jump to logging.rs
;;   4. Press C-c p s g → search for "handle_click" across all files
;;
;; TIP: After pressing C-c p, wait a moment - which-key will show all options!
(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(setq projectile-tags-command "ctags -e -R -f \"%s\"")
(setq projectile-tags-file-name "TAGS")

;; Magit: Professional Git interface - the best way to use Git
;; Replaces command-line git with an interactive, visual interface
;;
;; MAIN COMMAND:
;;   C-x g  - Open Magit status buffer (like 'git status' but interactive)
;;
;; IN MAGIT STATUS BUFFER:
;;   s      - Stage file/hunk under cursor (git add)
;;   u      - Unstage file/hunk (git reset)
;;   c c    - Commit (opens editor for message, C-c C-c to finish)
;;   P p    - Push to remote (git push)
;;   F p    - Pull from remote (git pull)
;;   b b    - Switch branches
;;   b c    - Create new branch
;;   l l    - View commit log
;;   d d    - View diff of file under cursor
;;   k      - Discard changes (careful!)
;;   g      - Refresh status
;;   TAB    - Expand/collapse section
;;   q      - Quit magit buffer
;;
;; WORKFLOW EXAMPLE:
;;   1. Make changes to files
;;   2. Press C-x g to see status
;;   3. Move cursor to changed file, press 's' to stage
;;   4. Press 'c c' to commit, write message, C-c C-c to finish
;;   5. Press 'P p' to push
;;
;; TIP: Magit is SO good that many developers use Emacs just for this!
(use-package magit
  :bind ("C-x g" . magit-status))

;; Undo-tree: Visual undo/redo with branching history
;; Normal undo is linear - this shows a tree of all your edits
;;
;; COMMANDS:
;;   C-x u   - Open undo-tree visualizer (shows tree of changes)
;;   C-/     - Undo (or C-_ or C-x u in text)
;;   C-?     - Redo (or M-_)
;;
;; IN UNDO-TREE VISUALIZER:
;;   p/n     - Move back/forward in history (up/down tree)
;;   b/f     - Switch branches (left/right in tree)
;;   t       - Toggle timestamps
;;   q       - Quit visualizer
;;
;; WHAT IT SOLVES:
;;   Normal undo: You make changes → undo → undo → make new change → CAN'T get back to undone work!
;;   Undo-tree: ALL changes are saved in a tree - you can navigate to ANY previous state
;;
;; EXAMPLE:
;;   1. Write "hello"
;;   2. Undo → write "goodbye"
;;   3. Undo tree lets you get back to "hello" even though you made new changes!
;;
;; TIP: C-x u to see the visual tree when you're lost in undo history
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  ;; Save undo history to ~/.emacs.d/undo-tree/ instead of project directories
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree/"))))

;; Company: Code completion (shows autocomplete suggestions as you type)
;; Works with LSP to provide intelligent completions
;;
;; USAGE (when enabled):
;;   Just start typing → popup shows completions after a brief delay
;;   M-n / M-p      - Navigate down/up in completion list
;;   TAB or RET     - Accept selected completion
;;   C-g            - Cancel completion
;;   M-<digit>      - Quickly select completion by number (M-1, M-2, etc.)
;;
;; CURRENTLY: Disabled globally (enable by uncommenting line below)
;;
;; WHY DISABLED:
;;   LSP already provides completions - Company just makes the popup nicer
;;   You can enable if you want prettier completion popups
;;
;; TO ENABLE:
;;   Uncomment the line: (add-hook 'after-init-hook 'global-company-mode)
;;   Restart Emacs → you'll get popup completions everywhere
;;
;; TIP: Try it both ways - some prefer LSP's default completion, some prefer Company's popups
(use-package company
  :config
  ;; Uncomment to enable globally for prettier completion popups
  (add-hook 'after-init-hook 'global-company-mode)
  )


;; Company-web: HTML/CSS/JavaScript completion for Company mode
;; Provides autocomplete for web technologies (HTML tags, CSS properties, etc.)
;;
;; USAGE:
;;   Automatically works when Company mode is enabled in web-related files
;;   Type '<div' → see HTML tag completions
;;   Type 'background-' → see CSS property completions
;;
;; REQUIRES: Company mode to be enabled (see above)
;;
;; NOTE: Works automatically, no commands to learn
(use-package company-web)

;; Flyspell: Spell checking
(use-package flyspell
  :hook (prog-mode . flyspell-prog-mode))

;; LSP Mode: Language Server Protocol
(use-package lsp-mode
  :commands lsp
  :hook ((python-mode . lsp)
         (rust-mode . lsp)
         (typescript-mode . lsp)
         (svelte-mode . lsp)
         (sh-mode . lsp))
  :config
  (setq lsp-enable-snippet nil))  ; Disable snippets

(use-package lsp-ui
  :commands lsp-ui-mode)

;; Language modes
(use-package markdown-mode
  :mode "\\.md\\'")

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . display-line-numbers-mode))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . display-line-numbers-mode))

(use-package svelte-mode
  :mode "\\.svelte\\'"
  :hook (svelte-mode . display-line-numbers-mode))

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package json-mode
  :mode "\\.json\\'")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROGRAMMING MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax highlighting
(global-font-lock-mode t)

;; Auto-fill in text/code modes
(add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'shell-script-mode-hook 'turn-on-auto-fill)

;;; LSP Language Server Installation Instructions:
;; rustup component add rust-analyzer
;; npm install -g typescript-language-server typescript
;; npm install -g svelte-language-server
;; pip install python-lsp-server --break-system-packages
;; npm install -g bash-language-server
;; npm install -g shellcheck

;; Add NVM's current node version to PATH
(let ((nvm-current "/home/stan/.nvm/versions/node/v20.20.2/bin"))
  (when (file-directory-p nvm-current)
    (setenv "PATH" (concat nvm-current ":" (getenv "PATH")))
    (add-to-list 'exec-path nvm-current)))

;; Python
(add-hook 'python-mode-hook 'hs-minor-mode)  ; Code folding

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
;; ENCRYPTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'epa-file)
(epa-file-enable)

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COLOR THEME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cycle-my-themes ()
  "Cycle between cornsilk, midnight-silk, and modus-vivendi-deuteranopia themes."
  (interactive)
  (cond
   ((member 'cornsilk custom-enabled-themes)
    (disable-theme 'cornsilk)
    (load-theme 'midnight-silk t)
    (message "Switched to midnight-silk (dark cornsilk)"))
   ((member 'midnight-silk custom-enabled-themes)
    (disable-theme 'midnight-silk)
    (load-theme 'modus-vivendi-deuteranopia t)
    (message "Switched to modus-vivendi-deuteranopia"))
   (t
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme 'cornsilk t)
    (message "Switched to cornsilk (light)"))))

(global-set-key (kbd "C-c t") 'cycle-my-themes)


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'midnight-silk t)


;; Clipboard integration
(setq x-select-enable-clipboard t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM-SET-VARIABLES (auto-generated)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b05ec53e77a84979bd32c001c632e66ab24dc055908d7fe052f8628bfdbe4ad9"
     "04845a52986e2b78c4cb47abda3d1339c5024a66fee86447410f34010ef8d8b9"
     "92b1d6e72b97bd74b5ddab60df19bb99e93a196c6e4575e6ef5c0319a30f11f5"
     "49af87a7ea1fe48b52a25fbf77dbeaecc9a2c906e0382e8f15e9e5b54055bba3"
     "1c5a8309b824269bb1e4b0008d7b16d488a3c10dc512303ce60713a2a4a7132f"
     "905a3da98fafb02a446b434697ad13a0478d27f8e6f65c507c2d058eaf104cf9"
     "07783027a35efa8215d4a043137072a98a67d6a924c5144814e2abcf11795175"
     "aad56641f43f151b4225771a4032dc890c044891cdcaf0d477029e26585ead6e"
     "b759ae60ce566580bbe90446e7fbeffdb103b3fcd43be369da1b3b68e1f2b267"
     "2cf8fe6f700bd3cc5cf6add20dac9c406364119da6d4417e52cc7ec4803e998b"
     default))
 '(diff-switches "-u")
 '(package-selected-packages nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; END OF CONFIGURATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
