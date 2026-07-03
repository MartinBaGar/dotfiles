;;; doom-feather-stone-theme.el --- calm, neutral variant of doom-feather-light -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Derived from doom-feather-light by Lena SAVY-LARIGALDIE
;; https://github.com/Plunne/doom-feather-theme
;;
;; Palette shifted from lavender/magenta to cool grey-blue/slate.
;; Retains the smooth, low-contrast feel of feather-light.
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-feather-stone-theme nil
  "Options for the `doom-feather-stone' theme."
  :group 'doom-themes)

(defcustom doom-feather-stone-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-feather-stone-theme
  :type 'boolean)

(defcustom doom-feather-stone-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-feather-stone-theme
  :type 'boolean)

(defcustom doom-feather-stone-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-feather-stone-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-feather-stone
    "A calm, neutral light theme derived from doom-feather-light.
Same smooth, relaxed feel — lavender and magenta replaced with
cool grey-blue, slate and teal."

  ;; name        default   256       16
  ;; Background is a neutral cool off-white, not lavender.
  ((bg         '("#f0f1f3" "#ffffff" "white"        ))
   (fg         '("#2c3240" "#303030" "black"        ))

   (bg-alt     '("#e5e7ea" "#e4e4e4" "white"        ))
   (fg-alt     '("#606878" "#606060" "brightblack"  ))

   ;; Base scale: cool neutral grey, bg→fg
   (base0      '("#e5e7ea" "#eeeeee" "white"        ))
   (base1      '("#d9dbdf" "#e0e0e0" "brightblack"  ))
   (base2      '("#cdd0d4" "#d0d0d0" "brightblack"  ))
   (base3      '("#b2b6bc" "#b8b8b8" "brightblack"  ))
   (base4      '("#919599" "#909090" "brightblack"  ))
   (base5      '("#666c72" "#666666" "brightblack"  ))
   (base6      '("#3a4048" "#404040" "brightblack"  ))
   (base7      '("#252b33" "#262626" "brightblack"  ))
   (base8      '("#141820" "#121212" "black"        ))

   (grey       base4)
   (red        '("#b84242" "#b84242" "red"          ))
   (orange     '("#b06030" "#b06030" "brightred"    ))
   (green      '("#4a7a3d" "#4a7a3d" "green"        ))
   (teal       '("#2e7878" "#007878" "brightgreen"  ))
   (yellow     '("#8a6800" "#875f00" "yellow"       ))
   (blue       '("#2f60a0" "#0067af" "brightblue"   ))
   (dark-blue  '("#1a4080" "#005faf" "blue"         ))
   ;; slate replaces violet — more grey-blue, less purple
   (violet     '("#5a6a9a" "#5f6faf" "brightmagenta"))
   ;; steel replaces magenta — a muted teal-cyan, nothing pink
   (magenta    '("#2e8070" "#007878" "magenta"      ))
   (cyan       '("#1a7890" "#0087af" "brightcyan"   ))
   (dark-cyan  '("#1a4a58" "#005f5f" "cyan"         ))

   ;; Semantic roles
   (highlight      teal)
   (vertical-bar   (doom-darken base2 0.1))
   (selection      dark-blue)
   (builtin        blue)
   (comments       (if doom-feather-stone-brighter-comments cyan base4))
   (doc-comments   (doom-darken comments 0.15))
   (constants      teal)
   (functions      blue)
   (keywords       violet)   ; slate-blue — calm, not purple
   (methods        cyan)
   (operators      teal)     ; was magenta — now muted teal
   (type           teal)     ; was magenta — now muted teal
   (strings        green)
   (variables      (doom-darken violet 0.4))
   (numbers        teal)
   (region         `(,(doom-darken (car bg-alt) 0.1) ,@(doom-darken (cdr base0) 0.3)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   (modeline-fg              fg)
   (modeline-fg-alt          (doom-blend violet base4
                                         (if doom-feather-stone-brighter-modeline 0.5 0.2)))
   (modeline-bg              (if doom-feather-stone-brighter-modeline
                                 (doom-darken base2 0.05)
                               base1))
   (modeline-bg-alt          (if doom-feather-stone-brighter-modeline
                                 (doom-darken base2 0.1)
                               base2))
   (modeline-bg-inactive     (doom-darken bg 0.1))
   (modeline-bg-alt-inactive `(,(doom-darken (car bg-alt) 0.05) ,@(cdr base1)))

   (-modeline-pad
    (when doom-feather-stone-padded-modeline
      (if (integerp doom-feather-stone-padded-modeline) doom-feather-stone-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((line-number &override) :foreground (doom-lighten base4 0.15))
   ((line-number-current-line &override) :background bg :foreground base5)
   ((font-lock-comment-face &override)
    :background (if doom-feather-stone-brighter-comments base0 'unspecified) :italic t)
   ((font-lock-doc-face &override) :slant 'italic)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if doom-feather-stone-brighter-modeline base8 highlight))
   (shadow :foreground base4)
   (tooltip :background base1 :foreground fg)
   ;;;; button
   (button :foreground strings)
   ;;;; centaur-tabs
   (centaur-tabs-unselected :background bg-alt :foreground base4)
   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; dashboard
   (dashboard-navigator :foreground teal)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if doom-feather-stone-brighter-modeline modeline-bg highlight))
   ;;;; ediff <built-in>
   (ediff-current-diff-A        :foreground red   :background (doom-lighten red 0.8))
   (ediff-current-diff-B        :foreground green :background (doom-lighten green 0.8))
   (ediff-current-diff-C        :foreground blue  :background (doom-lighten blue 0.8))
   (ediff-current-diff-Ancestor :foreground teal  :background (doom-lighten teal 0.8))
   ;;;; helm
   (helm-candidate-number :background blue :foreground bg)
   ;;;; ivy
   (ivy-current-match :background base2 :distant-foreground fg :weight 'normal)
   ;;;; lsp-mode
   (lsp-ui-doc-background :background base0)
   ;;;; magit
   (magit-blame-heading     :foreground orange :background bg-alt)
   (magit-diff-removed :foreground (doom-darken red 0.2) :background (doom-blend red bg 0.1))
   (magit-diff-removed-highlight :foreground red :background (doom-blend red bg 0.2) :bold bold)
   ;;;; markdown-mode
   (markdown-markup-face     :foreground base5)
   (markdown-header-face     :inherit 'bold :foreground blue)
   ((markdown-code-face &override) :background base1)
   (mmm-default-submode-face :background base1)
   ;;;; Outlines — rotated through blue/teal/slate instead of magenta/violet
   (outline-1 :height 1.8 :foreground blue   :weight 'bold)
   (outline-2 :height 1.2 :foreground teal   :weight 'bold)
   (outline-3 :height 1.1 :foreground violet :weight 'bold)
   (outline-4 :height 1.0 :foreground (doom-darken blue 0.25) :weight 'bold)
   (outline-5 :height 1.0 :foreground (doom-darken teal 0.25) :weight 'bold)
   (outline-6 :height 1.0 :foreground (doom-darken violet 0.25) :weight 'bold)
   (outline-7 :height 1.0 :foreground (doom-darken teal 0.5) :weight 'bold)
   (outline-8 :height 1.0 :foreground (doom-darken violet 0.5) :weight 'bold)
   ;;;; org <built-in>
   ((org-block &override) :background base1)
   ((org-block-begin-line &override) :foreground comments)
   (org-ellipsis :underline nil :background bg :foreground teal)
   ((org-quote &override) :background base1)
   ;;;; posframe
   (ivy-posframe :background base0)
   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground blue)
   (rainbow-delimiters-depth-2-face :foreground teal)
   (rainbow-delimiters-depth-3-face :foreground cyan)
   (rainbow-delimiters-depth-4-face :foreground violet)
   (rainbow-delimiters-depth-5-face :foreground green)
   (rainbow-delimiters-depth-6-face :foreground orange)
   (rainbow-delimiters-depth-7-face :foreground red)
   (rainbow-delimiters-depth-8-face :foreground yellow)
   (rainbow-delimiters-depth-9-face :foreground dark-cyan)
   ;;;; selectrum
   (selectrum-current-candidate :background base2)
   ;;;; Treemacs
   (treemacs-root-face :foreground teal :weight 'bold :height 1.4)
   (doom-themes-treemacs-root-face :foreground teal :weight 'ultra-bold :height 1.2)
   ;;;; Tree-sitter
   (tree-sitter-hl-face:punctuation.bracket :foreground comments)
   (tree-sitter-hl-face:attribute           :foreground violet)
   (tree-sitter-hl-face:function\.call      :foreground blue)
   (tree-sitter-hl-face:function\.macro     :foreground blue)
   (tree-sitter-hl-face:type\.builtin       :foreground teal :italic t)
   (tree-sitter-hl-face:variable\.special   :foreground constants)
   (tree-sitter-hl-face:operator            :foreground operators)
   ;;;; vertico
   (vertico-current :background base2)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-alt-inactive
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt-inactive)))
   ;;;; web-mode
   (web-mode-current-element-highlight-face :background dark-blue :foreground bg)
   ;;;; wgrep <built-in>
   (wgrep-face :background base1)
   ;;;; whitespace
   ((whitespace-tab &override)
    :background (if (not (default-value 'indent-tabs-mode)) base0 'unspecified))
   ((whitespace-indentation &override)
    :background (if (default-value 'indent-tabs-mode) base0 'unspecified)))

  ;;;; Base theme variable overrides
  ()
  )

;;; doom-feather-stone-theme.el ends here
