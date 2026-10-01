;;; spacegrey-light-theme.el --- Vanilla port of doom-spacegrey-light -*- lexical-binding: t; -*-

(deftheme spacegrey-light "A light theme inspired by Atom Spacegrey, ported from Doom.")

(let ((bg         "#f5f6f8")
      (bg-alt     "#eaecf0")
      (base0      "#ffffff")
      (base1      "#f5f6f8")
      (base2      "#eaecf0")
      (base3      "#d8dce4")
      (base4      "#adb4bf")
      (base5      "#7e8a96")
      (base6      "#65737e")
      (base7      "#3e4c59")
      (base8      "#1b2229")
      (fg         "#2b303b")
      (fg-alt     "#343d46")
      (grey       "#adb4bf")
      (red        "#c0434e")
      (orange     "#b35c3a")
      (green      "#4a7a3d")
      (blue       "#3d6680")
      (violet     "#7c5c8e")
      (teal       "#2e7d82")
      (yellow     "#8a6200")
      (dark-blue  "#2257A0")
      (magenta    "#8f3fa8")
      (cyan       "#0a7fa8")
      (dark-cyan  "#2a6475")
      
      ;; Pre-calculated blends and shades from the Doom macros
      (org-block-bg "#e2e4e8")
      (org-meta-bg  "#ebecf0")
      (modeline-inactive-bg "#f2f4f6")
      (out2 "#334353")
      (out3 "#39576a")
      (out5 "#7f4699")
      (out6 "#6f4c8b")
      (out7 "#5f547c"))

  (custom-theme-set-faces
   'spacegrey-light

   ;; Core UI
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,blue))))
   `(region ((t (:background ,base3 :extend t))))
   `(fringe ((t (:background ,bg :foreground ,base4))))
   `(vertical-border ((t (:foreground ,base3))))
   `(line-number ((t (:foreground ,base4))))
   `(line-number-current-line ((t (:foreground ,fg :weight bold))))
   `(minibuffer-prompt ((t (:foreground ,blue :weight bold))))
   `(error ((t (:foreground ,red :weight bold))))
   `(warning ((t (:foreground ,yellow :weight bold))))
   `(success ((t (:foreground ,green :weight bold))))

   ;; Modeline
   `(mode-line ((t (:background ,base2 :foreground ,fg-alt :box nil))))
   `(mode-line-inactive ((t (:background ,modeline-inactive-bg :foreground ,base5 :box nil))))
   `(mode-line-emphasis ((t (:foreground ,orange :weight bold))))

   ;; Syntax Highlighting
   `(font-lock-builtin-face ((t (:foreground ,orange))))
   `(font-lock-comment-face ((t (:foreground ,base5 :slant italic))))
   `(font-lock-doc-face ((t (:foreground ,base5 :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,orange))))
   `(font-lock-function-name-face ((t (:foreground ,blue))))
   `(font-lock-keyword-face ((t (:foreground ,violet))))
   `(font-lock-string-face ((t (:foreground ,green))))
   `(font-lock-type-face ((t (:foreground ,yellow))))
   `(font-lock-variable-name-face ((t (:foreground ,red))))

   ;; Outline (Headers)
   `(outline-1 ((t (:foreground ,fg :weight ultra-bold))))
   `(outline-2 ((t (:foreground ,out2 :weight bold))))
   `(outline-3 ((t (:foreground ,out3 :weight bold))))
   `(outline-4 ((t (:foreground ,blue :weight bold))))
   `(outline-5 ((t (:foreground ,out5 :weight bold))))
   `(outline-6 ((t (:foreground ,out6 :weight bold))))
   `(outline-7 ((t (:foreground ,out7 :weight bold))))
   `(outline-8 ((t (:foreground ,fg :weight bold))))

   ;; Org Mode
   `(org-document-title ((t (:foreground ,blue :weight bold :height 1.2))))
   `(org-block ((t (:inherit fixed-pitch :background ,org-block-bg :extend t))))
   `(org-block-begin-line ((t (:inherit fixed-pitch :foreground ,base4 :slant italic :background ,org-meta-bg :extend t))))
   `(org-block-end-line ((t (:inherit fixed-pitch :foreground ,base4 :slant italic :background ,org-meta-bg :extend t))))
   `(org-quote ((t (:background ,base2 :extend t :slant italic))))
   `(org-ellipsis ((t (:foreground ,red :underline nil))))
   `(org-hide ((t (:foreground ,bg))))
   `(org-code ((t (:inherit fixed-pitch :foreground ,green))))
   `(org-verbatim ((t (:inherit fixed-pitch :foreground ,green))))
   `(org-table ((t (:inherit fixed-pitch :foreground ,blue))))

   ;; Markdown Mode
   `(markdown-markup-face ((t (:foreground ,base5))))
   `(markdown-header-face ((t (:inherit bold :foreground ,red))))
   `(markdown-code-face ((t (:inherit fixed-pitch :background ,org-meta-bg))))
   
   ;; CSS Mode
   `(css-proprietary-property ((t (:foreground ,orange))))
   `(css-property ((t (:foreground ,fg))))
   `(css-selector ((t (:foreground ,red))))))

(provide-theme 'spacegrey-light)
;;; spacegrey-light-theme.el ends here
