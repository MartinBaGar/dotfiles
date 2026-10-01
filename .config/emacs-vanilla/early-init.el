;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Raise the GC threshold for the *entire* startup sequence (Elpaca
;; bootstrap, package loads, org tangling in init.el) and only reset it
;; once startup has fully finished, via `emacs-startup-hook'. Resetting
;; it synchronously here, before init.el even runs, would defeat the
;; whole point of raising it in the first place.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Disable package.el to let elpaca operate
(setq package-enable-at-startup nil)

;; Disable bloat modes
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Frame settings
(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize 'force
      frame-title-format '("%b")
      ring-bell-function 'ignore
      use-dialog-box t ; only for mouse events, which I seldom use
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name ; read the docstring
      inhibit-startup-buffer-menu t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;;; early-init.el ends here
