;;; spacegrey-theme.el --- Vanilla port of doom-spacegrey -*- lexical-binding: t; -*-

(deftheme spacegrey "A dark theme inspired by Atom Spacegrey Dark, ported from Doom.")

(let ((bg         "#2b303b")
      (bg-alt     "#232830")
      (base0      "#1B2229")
      (base1      "#1c1f24")
      (base2      "#202328")
      (base3      "#2F3237")
      (base4      "#4f5b66")
      (base5      "#65737E")
      (base6      "#73797e")
      (base7      "#9ca0a4")
      (base8      "#DFDFDF")
      (fg         "#c0c5ce")
      (fg-alt     "#c0c5ce")
      (grey       "#4f5b66")
      (red        "#BF616A")
      (orange     "#D08770")
      (green      "#A3BE8C")
      (blue       "#8FA1B3")
      (violet     "#b48ead")
      (teal       "#4db5bd")
      (yellow     "#ECBE7B")
      (dark-blue  "#2257A0")
      (magenta    "#c678dd")
      (cyan       "#46D9FF")
      (dark-cyan  "#5699AF")
      
      ;; Pre-calculated blends and shades from the Doom macros
      (org-block-bg "#21262e")
      (org-meta-bg  "#272b35")
      (modeline-inactive-bg "#21262d")
      (doc-comments "#7e8f9d")
      (out2 "#a1adb9")
      (out3 "#b1b9c3")
      (out5 "#9aa1be")
      (out6 "#a599c7")
      (out7 "#b088cc"))

  (custom-theme-set-faces
   'spacegrey

   ;; Core UI
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,blue))))
   `(region ((t (:background ,base4 :extend t))))
   `(fringe ((t (:background ,bg :foreground ,base4))))
   `(vertical-border ((t (:foreground ,base0))))
   `(line-number ((t (:foreground ,base4))))
   `(line-number-current-line ((t (:foreground ,fg :weight bold))))
   `(minibuffer-prompt ((t (:foreground ,blue :weight bold))))
   `(error ((t (:foreground ,red :weight bold))))
   `(warning ((t (:foreground ,yellow :weight bold))))
   `(success ((t (:foreground ,green :weight bold))))

   ;; Modeline
   `(mode-line ((t (:background ,base1 :foreground ,fg-alt :box nil))))
   `(mode-line-inactive ((t (:background ,modeline-inactive-bg :foreground ,base5 :box nil))))
   `(mode-line-emphasis ((t (:foreground ,orange :weight bold))))

   ;; Syntax Highlighting
   `(font-lock-builtin-face ((t (:foreground ,orange))))
   `(font-lock-comment-face ((t (:foreground ,base5 :slant italic))))
   `(font-lock-doc-face ((t (:foreground ,doc-comments :slant italic))))
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
   `(org-block ((t (:background ,org-block-bg :extend t))))
   `(org-block-begin-line ((t (:foreground ,base4 :slant italic :background ,org-meta-bg :extend t))))
   `(org-block-end-line ((t (:foreground ,base4 :slant italic :background ,org-meta-bg :extend t))))
   `(org-quote ((t (:background ,base1 :extend t :slant italic))))
   `(org-ellipsis ((t (:foreground ,red :underline nil))))
   `(org-hide ((t (:foreground ,bg))))

   ;; Markdown Mode
   `(markdown-markup-face ((t (:foreground ,base5))))
   `(markdown-header-face ((t (:inherit bold :foreground ,red))))
   `(markdown-code-face ((t (:background ,org-meta-bg))))

   ;; CSS Mode
   `(css-proprietary-property ((t (:foreground ,orange))))
   `(css-property ((t (:foreground ,fg))))
   `(css-selector ((t (:foreground ,red))))))

(provide-theme 'spacegrey)
;;; spacegrey-theme.el ends here
