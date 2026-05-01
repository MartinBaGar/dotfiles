;;; doom-feather-hearth-theme.el --- warm, cozy variant of doom-feather-light -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Derived from doom-feather-light by Lena SAVY-LARIGALDIE
;; https://github.com/Plunne/doom-feather-theme
;;
;; Palette: warm parchment backgrounds, amber, terracotta, moss green,
;; and dusty slate. Think lamplight, old paper, a lived-in library.
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-feather-hearth-theme nil
  "Options for the `doom-feather-hearth' theme."
  :group 'doom-themes)

(defcustom doom-feather-hearth-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-feather-hearth-theme
  :type 'boolean)

(defcustom doom-feather-hearth-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-feather-hearth-theme
  :type 'boolean)

(defcustom doom-feather-hearth-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-feather-hearth-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-feather-hearth
    "A warm, cozy light theme derived from doom-feather-light.
Same smooth, relaxed feel — lavender replaced with parchment and amber,
magenta replaced with earthy terracotta and moss."

  ;; name        default   256       16
  ;; Warm parchment base — like paper under a lamp
  ((bg         '("#f4efe4" "#ffffff" "white"        ))
   (fg         '("#2c2418" "#2a2a2a" "black"        ))

   (bg-alt     '("#ece5d7" "#e4e0d8" "white"        ))
   (fg-alt     '("#6a5a46" "#5e5e5e" "brightblack"  ))

   ;; Base scale: warm grey, bg→fg
   (base0      '("#ece5d7" "#eeeeee" "white"        ))
   (base1      '("#e2dace" "#e0dcd4" "brightblack"  ))
   (base2      '("#d5ccbc" "#ccc8bc" "brightblack"  ))
   (base3      '("#bab0a0" "#b8b0a0" "brightblack"  ))
   (base4      '("#9a8e7e" "#948e82" "brightblack"  ))
   (base5      '("#72665a" "#6e6560" "brightblack"  ))
   (base6      '("#3e3028" "#403830" "brightblack"  ))
   (base7      '("#28201a" "#282018" "brightblack"  ))
   (base8      '("#161008" "#141210" "black"        ))

   (grey       base4)
   ;; Brick red — grounded, not aggressive
   (red        '("#b04848" "#b04848" "red"          ))
   ;; Amber/terracotta — the warmest accent, replaces orange & magenta
   (orange     '("#b86830" "#b86830" "brightred"    ))
   ;; Moss/olive green — earthy, not cool
   (green      '("#587840" "#578040" "green"        ))
   ;; Warm teal — like verdigris on copper
   (teal       '("#3a7068" "#007868" "brightgreen"  ))
   ;; Warm amber-gold
   (yellow     '("#987000" "#8a6800" "yellow"       ))
   ;; Slate blue — warm-leaning, the one cool note to balance the palette
   (blue       '("#4a6898" "#4a6898" "brightblue"   ))
   (dark-blue  '("#2a4878" "#2a4878" "blue"         ))
   ;; Dusty mauve — the old `violet', now warm and muted, not purple
   (violet     '("#806070" "#7a6070" "brightmagenta"))
   ;; Warm teal stands in for magenta throughout
   (magenta    teal)
   (cyan       '("#3a7880" "#3a7880" "brightcyan"   ))
   (dark-cyan  '("#1e4850" "#1e4850" "cyan"         ))

   ;; Semantic roles
   (highlight      orange)
   (vertical-bar   (doom-darken base2 0.1))
   (selection      dark-blue)
   (builtin        orange)
   (comments       (if doom-feather-hearth-brighter-comments teal base4))
   (doc-comments   (doom-darken comments 0.15))
   (constants      teal)
   (functions      blue)
   (keywords       violet)   ; dusty mauve — warm but subdued
   (methods        cyan)
   (operators      teal)     ; warm teal instead of pink magenta
   (type           teal)     ; same
   (strings        green)    ; moss green
   (variables      (doom-darken red 0.1))
   (numbers        orange)   ; warm amber for numbers
   (region         `(,(doom-darken (car bg-alt) 0.1) ,@(doom-darken (cdr base0) 0.3)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   (modeline-fg              fg)
   (modeline-fg-alt          (doom-blend violet base4
                                         (if doom-feather-hearth-brighter-modeline 0.5 0.2)))
   (modeline-bg              (if doom-feather-hearth-brighter-modeline
                                 (doom-darken base2 0.05)
                               base1))
   (modeline-bg-alt          (if doom-feather-hearth-brighter-modeline
                                 (doom-darken base2 0.1)
                               base2))
   (modeline-bg-inactive     (doom-darken bg 0.08))
   (modeline-bg-alt-inactive `(,(doom-darken (car bg-alt) 0.05) ,@(cdr base1)))

   (-modeline-pad
    (when doom-feather-hearth-padded-modeline
      (if (integerp doom-feather-hearth-padded-modeline) doom-feather-hearth-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((line-number &override) :foreground (doom-lighten base4 0.15))
   ((line-number-current-line &override) :background bg :foreground base5)
   ((font-lock-comment-face &override)
    :background (if doom-feather-hearth-brighter-comments base0 'unspecified) :italic t)
   ((font-lock-doc-face &override) :slant 'italic)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if doom-feather-hearth-brighter-modeline base8 highlight))
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
   (doom-modeline-bar :background (if doom-feather-hearth-brighter-modeline modeline-bg highlight))
   ;;;; ediff <built-in>
   (ediff-current-diff-A        :foreground red    :background (doom-lighten red 0.8))
   (ediff-current-diff-B        :foreground green  :background (doom-lighten green 0.8))
   (ediff-current-diff-C        :foreground blue   :background (doom-lighten blue 0.8))
   (ediff-current-diff-Ancestor :foreground teal   :background (doom-lighten teal 0.8))
   ;;;; helm
   (helm-candidate-number :background orange :foreground bg)
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
   (markdown-header-face     :inherit 'bold :foreground orange)
   ((markdown-code-face &override) :background base1)
   (mmm-default-submode-face :background base1)
   ;;;; Outlines — warm rotation: amber → teal → slate → moss
   (outline-1 :height 1.8 :foreground orange :weight 'bold)
   (outline-2 :height 1.2 :foreground teal   :weight 'bold)
   (outline-3 :height 1.1 :foreground blue   :weight 'bold)
   (outline-4 :height 1.0 :foreground (doom-darken orange 0.2) :weight 'bold)
   (outline-5 :height 1.0 :foreground (doom-darken teal 0.2)   :weight 'bold)
   (outline-6 :height 1.0 :foreground (doom-darken blue 0.2)   :weight 'bold)
   (outline-7 :height 1.0 :foreground (doom-darken teal 0.4)   :weight 'bold)
   (outline-8 :height 1.0 :foreground (doom-darken violet 0.3) :weight 'bold)
   ;;;; org <built-in>
   ((org-block &override) :background base1)
   ((org-block-begin-line &override) :foreground comments)
   (org-ellipsis :underline nil :background bg :foreground orange)
   ((org-quote &override) :background base1)
   ;;;; posframe
   (ivy-posframe :background base0)
   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground blue)
   (rainbow-delimiters-depth-2-face :foreground teal)
   (rainbow-delimiters-depth-3-face :foreground orange)
   (rainbow-delimiters-depth-4-face :foreground violet)
   (rainbow-delimiters-depth-5-face :foreground green)
   (rainbow-delimiters-depth-6-face :foreground cyan)
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
   (tree-sitter-hl-face:function\.macro     :foreground orange)
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

;;; doom-feather-hearth-theme.el ends here
