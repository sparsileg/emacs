;;; cornsilk-theme.el --- Stan's classic cornsilk theme

(deftheme cornsilk
  "Classic light theme with cornsilk background - Stan's longtime preference")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'cornsilk

   ;; Basic colors and font
   `(default ((,class (:foreground "black"
                       :background "cornsilk"
                       :family "DejaVu Sans Mono"
                       :height 90
                       :weight bold))))
   `(cursor ((,class (:background "blue"))))
   `(region ((,class (:foreground "white" :background "blue"))))

   ;; Syntax highlighting
   `(font-lock-comment-face ((,class (:foreground "blue"))))
   `(font-lock-string-face ((,class (:foreground "dark green"))))
   `(font-lock-keyword-face ((,class (:foreground "purple"))))
   `(font-lock-function-name-face ((,class (:foreground "blue"))))
   `(font-lock-variable-name-face ((,class (:foreground "dark orange"))))

   ;; UI elements
   `(highlight ((,class (:foreground "black" :background "lightblue"))))
   `(secondary-selection ((,class (:foreground "black" :background "yellow"))))

   ;; Text emphasis
   `(bold ((,class (:foreground "yellow" :background "grey40" :weight bold))))
   `(bold-italic ((,class (:foreground "yellow green" :weight bold :slant italic))))
   `(italic ((,class (:foreground "yellow3" :slant italic))))

   ;; Mode line
   `(mode-line ((,class (:background "grey75" :foreground "black"))))
   `(mode-line-inactive ((,class (:background "grey90" :foreground "grey20"))))))

(provide-theme 'cornsilk)

;;; cornsilk-theme.el ends here
