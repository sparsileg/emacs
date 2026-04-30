;;; midnight-silk-theme.el --- Dark version of Stan's cornsilk theme

(deftheme midnight-silk
  "Dark theme inspired by cornsilk - warm, high-contrast colors on dark background")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'midnight-silk

   ;; Basic colors and font - dark warm grey background instead of cornsilk
   `(default ((,class (:foreground "#e8d4b0"      ; Warm cream (like cornsilk but lighter)
                       :background "#1a1a24"       ; Very dark blue-grey
                       :family "DejaVu Sans Mono"
                       :height 100
                       :weight normal))))
   `(cursor ((,class (:background "#4fa5d5"))))    ; Bright blue (easy to spot)
   `(region ((,class (:foreground "#1a1a24" :background "#e8a75a")))) ; Dark bg, warm orange selection

   ;; Syntax highlighting - adjusted for dark background
   `(font-lock-comment-face ((,class (:foreground "#7fb4ca"))))  ; Sky blue (was blue)
   `(font-lock-string-face ((,class (:foreground "#98c379"))))   ; Soft green
   `(font-lock-keyword-face ((,class (:foreground "#c678dd"))))  ; Soft purple (was purple)
   `(font-lock-function-name-face ((,class (:foreground "#61afef")))) ; Bright blue
   `(font-lock-variable-name-face ((,class (:foreground "#e5c07b")))) ; Soft gold
   `(font-lock-constant-face ((,class (:foreground "#d19a66"))))      ; Warm orange
   `(font-lock-type-face ((,class (:foreground "#e06c75"))))          ; Soft red/pink

   ;; UI elements
   `(highlight ((,class (:foreground "#e8d4b0" :background "#2d3142")))) ; Subtle highlight
   `(hl-line ((,class (:foreground "#e8d4b0" :background "#2d3142"))))
   `(show-paren-match-expression ((,class (:foreground "#000000" :background "#aaaaaa"))))
   `(secondary-selection ((,class (:foreground "#1a1a24" :background "#c678dd")))) ; Purple

   ;; Text emphasis
   `(bold ((,class (:foreground "#e8a75a" :weight bold))))           ; Warm orange
   `(bold-italic ((,class (:foreground "#98c379" :weight bold :slant italic)))) ; Green
   `(italic ((,class (:foreground "#e5c07b" :slant italic))))        ; Gold

   ;; Mode line - distinct but not jarring
   `(mode-line ((,class (:background "#2d3142" :foreground "#e8d4b0"))))
   `(mode-line-inactive ((,class (:background "#1a1a24" :foreground "#6b7280"))))

   ;; Line numbers (if using display-line-numbers-mode)
   `(line-number ((,class (:foreground "#4a5568" :background "#1a1a24"))))
   `(line-number-current-line ((,class (:foreground "#e8a75a" :background "#2d3142" :weight bold))))))

(provide-theme 'midnight-silk)

;;; midnight-silk-theme.el ends here
