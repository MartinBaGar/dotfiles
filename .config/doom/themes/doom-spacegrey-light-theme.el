;;; doom-spacegrey-light-theme.el --- Light equivalent of doom-spacegrey -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: derived from teesloane's doom-spacegrey
;; Source: http://kkga.github.io/spacegray/
;;
;;; Commentary:
;;
;; A light counterpart to doom-spacegrey-theme, sharing its blue-grey
;; character but built on a bright, airy background.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-spacegrey-light-theme nil
  "Options for the `doom-spacegrey-light' theme."
  :group 'doom-themes)

(defcustom doom-spacegrey-light-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-spacegrey-light-theme
  :type 'boolean)

(defcustom doom-spacegrey-light-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-spacegrey-light-theme
  :type 'boolean)

(defcustom doom-spacegrey-light-comment-bg doom-spacegrey-light-brighter-comments
  "If non-nil, comments will have a subtle background, enhancing legibility."
  :group 'doom-spacegrey-light-theme
  :type 'boolean)

(defcustom doom-spacegrey-light-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-spacegrey-light-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-spacegrey-light
    "A light theme inspired by Atom Spacegrey, mirroring doom-spacegrey."

  ;; name        default   256       16
  ((bg         '("#f5f6f8" "white"   "white"        ))
   (bg-alt     '("#eaecf0" "white"   "white"        ))
   (base0      '("#ffffff" "white"   "white"        ))
   (base1      '("#f5f6f8" "#f4f4f4" "white"        ))
   (base2      '("#eaecf0" "#e0e0e0" "white"        ))
   (base3      '("#d8dce4" "#d0d0d0" "brightblack"  ))
   (base4      '("#adb4bf" "#aaaaaa" "brightblack"  ))
   (base5      '("#7e8a96" "#767676" "brightblack"  ))
   (base6      '("#65737e" "#626262" "brightblack"  ))
   (base7      '("#3e4c59" "#444444" "black"        ))
   (base8      '("#1b2229" "#1e1e1e" "black"        ))
   (fg         '("#2b303b" "#303030" "black"        ))
   (fg-alt     '("#343d46" "#3a3a3a" "black"        ))

   (grey       base4)
   (red        '("#c0434e" "#c0434e" "red"          ))
   (orange     '("#b35c3a" "#b35c3a" "brightred"    ))
   (green      '("#4a7a3d" "#4a7a3d" "green"        ))
   (blue       '("#3d6680" "#3d6680" "brightblue"   ))
   (violet     '("#7c5c8e" "#7c5c8e" "brightmagenta"))
   (teal       '("#2e7d82" "#2e7d82" "brightgreen"  ))
   (yellow     '("#8a6200" "#8a6200" "yellow"       ))
   (dark-blue  '("#2257A0" "#2257A0" "blue"         ))
   (magenta    '("#8f3fa8" "#8f3fa8" "magenta"      ))
   (cyan       '("#0a7fa8" "#0a7fa8" "brightcyan"   ))
   (dark-cyan  '("#2a6475" "#2a6475" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      orange)
   (vertical-bar   (doom-darken bg 0.15))
   (selection      base3)
   (builtin        orange)
   (comments       (if doom-spacegrey-light-brighter-comments dark-cyan base5))
   (doc-comments   (doom-darken (if doom-spacegrey-light-brighter-comments dark-cyan base5) 0.15))
   (constants      orange)
   (functions      blue)
   (keywords       violet)
   (methods        blue)
   (operators      fg)
   (type           yellow)
   (strings        green)
   (variables      red)
   (numbers        orange)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg-alt) "white" "white"))
   (-modeline-bright doom-spacegrey-light-brighter-modeline)
   (-modeline-pad
    (when doom-spacegrey-light-padded-modeline
      (if (integerp doom-spacegrey-light-padded-modeline) doom-spacegrey-light-padded-modeline 4)))

   (modeline-fg     fg-alt)
   (modeline-fg-alt (doom-blend violet base5 (if -modeline-bright 0.5 0.2)))
   (modeline-bg
    (if -modeline-bright
        (doom-lighten base3 0.1)
      base2))
   (modeline-bg-l
    (if -modeline-bright
        (doom-lighten base3 0.05)
      base2))
   (modeline-bg-inactive   `(,(doom-lighten (car bg-alt) 0.03) ,@(cdr base2)))
   (modeline-bg-inactive-l (doom-lighten bg 0.05)))


  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-spacegrey-light-comment-bg (doom-darken bg 0.04) 'unspecified))
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground fg)
   (css-selector             :foreground red)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#d8dce4" :foreground "#7e8a96")
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-darken bg 0.04))
   ;;;; outline <built-in>
   ((outline-1 &override) :foreground fg :weight 'ultra-bold)
   ((outline-2 &override) :foreground (doom-blend fg blue 0.35))
   ((outline-3 &override) :foreground (doom-blend fg blue 0.7))
   ((outline-4 &override) :foreground blue)
   ((outline-5 &override) :foreground (doom-blend magenta blue 0.2))
   ((outline-6 &override) :foreground (doom-blend magenta blue 0.4))
   ((outline-7 &override) :foreground (doom-blend magenta blue 0.6))
   ((outline-8 &override) :foreground fg)
   ;;;; org <built-in>
   (org-block            :background (doom-darken bg-alt 0.03))
   (org-block-begin-line :foreground base4 :slant 'italic :background (doom-darken bg 0.04))
   (org-ellipsis         :underline nil :background bg    :foreground red)
   ((org-quote &override) :background base2)
   (org-hide :foreground bg)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l))))

  ;;;; Base theme variable overrides
  ;; ()
  )

;;; doom-spacegrey-light-theme.el ends here
