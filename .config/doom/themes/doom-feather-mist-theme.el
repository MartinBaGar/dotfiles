;;; doom-feather-mist-theme.el --- a muted, peaceful variant of doom-feather-light -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Derived from doom-feather-light by Lena SAVY-LARIGALDIE
;; https://github.com/Plunne/doom-feather-theme
;;
;; Same lavender base and color family as feather-light.
;; All accents desaturated ~40-50% for a softer, more unified feel.
;; Nothing competes for attention; everything belongs to the same quiet mood.
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-feather-mist-theme nil
  "Options for the `doom-feather-mist' theme."
  :group 'doom-themes)

(defcustom doom-feather-mist-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-feather-mist-theme
  :type 'boolean)

(defcustom doom-feather-mist-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-feather-mist-theme
  :type 'boolean)

(defcustom doom-feather-mist-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-feather-mist-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-feather-mist
    "A peaceful, muted light theme based on doom-feather-light.
Same lavender background and color family — all accents desaturated
for a calm, unified feel where nothing fights for attention."

  ;; name        default   256       16
  ;; Background: identical to feather-light — the lavender is kept.
  ((bg         '("#F0EDF4" "#ffffff" "white"        ))
   (fg         '("#3e3050" "#424242" "black"        ))

   (bg-alt     '("#E8E4EE" "#e4e4e4" "white"        ))
   (fg-alt     '("#8a7aa0" "#949494" "brightblack"  ))

   ;; Base scale: identical to feather-light — the soft purple-grey steps are part of the charm.
   (base0      '("#E8E4EE" "#eeeeee" "white"        ))
   (base1      '("#E1DBE9" "#e4e4e4" "brightblack"  ))
   (base2      '("#D9D2E3" "#dadada" "brightblack"  ))
   (base3      '("#C3B7D2" "#c6c6c6" "brightblack"  ))
   (base4      '("#B4A5C7" "#b2b2b2" "brightblack"  ))
   (base5      '("#9783B1" "#949494" "brightblack"  ))
   (base6      '("#4A3B5E" "#424242" "brightblack"  ))
   (base7      '("#2A2236" "#262626" "brightblack"  ))
   (base8      '("#15111B" "#121212" "black"        ))

   (grey       base4)
   ;; All hues match feather-light but are significantly desaturated.
   ;; Red: was #dc322f — now a quiet dusty rose-brick
   (red        '("#a85c60" "#a85c60" "red"          ))
   ;; Orange: was #d75f00 — now a muted terracotta
   (orange     '("#9a6438" "#9a6438" "brightred"    ))
   ;; Green: was #5f8700 — now a soft sage
   (green      '("#5a7848" "#5a7848" "green"        ))
   ;; Teal: was #008070 — now a dusty teal
   (teal       '("#3a7870" "#3a7870" "brightgreen"  ))
   ;; Yellow: was #a07000 — now a muted ochre
   (yellow     '("#8a7030" "#8a7030" "yellow"       ))
   ;; Blue: was #007daf — now a soft slate blue, harmonises with lavender bg
   (blue       '("#4a7098" "#4a7098" "brightblue"   ))
   (dark-blue  '("#2a4878" "#2a4878" "blue"         ))
   ;; Violet: was #875faf — now a dusty lavender-purple, much closer to the bg family
   (violet     '("#7a6898" "#7a6898" "brightmagenta"))
   ;; Magenta: was #f4649b (vivid pink) — now a soft muted mauve, barely pink
   (magenta    '("#9a7090" "#9a7090" "magenta"      ))
   ;; Cyan: was #008ea1 — now a quiet blue-teal
   (cyan       '("#4a8898" "#4a8898" "brightcyan"   ))
   (dark-cyan  '("#204052" "#204052" "cyan"         ))

   ;; Semantic roles
   (highlight      base5)
   (vertical-bar   (doom-darken base2 0.1))
   (selection      dark-blue)
   (builtin        blue)
   (comments       (if doom-feather-mist-brighter-comments cyan base4))
   (doc-comments   (doom-darken comments 0.15))
   (constants      teal)
   (functions      blue)
   (keywords       violet)   ; dusty lavender-purple — in the same family as bg
   (methods        cyan)
   (operators      magenta)  ; soft muted mauve — was screaming pink, now a whisper
   (type           magenta)
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
                                         (if doom-feather-mist-brighter-modeline 0.5 0.2)))
   (modeline-bg              (if doom-feather-mist-brighter-modeline
                                 (doom-darken base2 0.05)
                               base1))
   (modeline-bg-alt          (if doom-feather-mist-brighter-modeline
                                 (doom-darken base2 0.1)
                               base2))
   (modeline-bg-inactive     (doom-darken bg 0.1))
   (modeline-bg-alt-inactive `(,(doom-darken (car bg-alt) 0.05) ,@(cdr base1)))

   (-modeline-pad
    (when doom-feather-mist-padded-modeline
      (if (integerp doom-feather-mist-padded-modeline) doom-feather-mist-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((line-number &override) :foreground (doom-lighten base4 0.15))
   ((line-number-current-line &override) :background bg :foreground base5)
   ((font-lock-comment-face &override)
    :background (if doom-feather-mist-brighter-comments base0 'unspecified) :italic t)
   ((font-lock-doc-face &override) :slant 'italic)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-mode-emphasis
    :foreground (if doom-feather-mist-brighter-modeline base8 highlight))
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
   (dashboard-navigator :foreground violet)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if doom-feather-mist-brighter-modeline modeline-bg highlight))
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
   (markdown-header-face     :inherit 'bold :foreground violet)
   ((markdown-code-face &override) :background base1)
   (mmm-default-submode-face :background base1)
   ;;;; Outlines — same hue rotation as feather-light, just desaturated
   (outline-1 :height 1.8 :foreground magenta :weight 'bold)
   (outline-2 :height 1.2 :foreground violet  :weight 'bold)
   (outline-3 :height 1.1 :foreground teal    :weight 'bold)
   (outline-4 :height 1.0 :foreground (doom-darken violet 0.2) :weight 'bold)
   (outline-5 :height 1.0 :foreground (doom-darken teal 0.2)   :weight 'bold)
   (outline-6 :height 1.0 :foreground (doom-darken violet 0.4) :weight 'bold)
   (outline-7 :height 1.0 :foreground (doom-darken teal 0.4)   :weight 'bold)
   (outline-8 :height 1.0 :foreground (doom-darken violet 0.6) :weight 'bold)
   ;;;; org <built-in>
   ((org-block &override) :background base1)
   ((org-block-begin-line &override) :foreground comments)
   (org-ellipsis :underline nil :background bg :foreground violet)
   ((org-quote &override) :background base1)
   ;;;; posframe
   (ivy-posframe :background base0)
   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground blue)
   (rainbow-delimiters-depth-2-face :foreground teal)
   (rainbow-delimiters-depth-3-face :foreground violet)
   (rainbow-delimiters-depth-4-face :foreground blue)
   (rainbow-delimiters-depth-5-face :foreground green)
   (rainbow-delimiters-depth-6-face :foreground orange)
   (rainbow-delimiters-depth-7-face :foreground red)
   (rainbow-delimiters-depth-8-face :foreground yellow)
   (rainbow-delimiters-depth-9-face :foreground magenta)
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
   (tree-sitter-hl-face:type\.builtin       :foreground magenta :italic t)
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

;;; doom-feather-mist-theme.el ends here
