;;; init.el --- Bootstrapper -*- lexical-binding: t; -*-

(setq load-prefer-newer t)

;; --- Elpaca bootstrap -----------------------------------------------
;; Lives here, in plain init.el, rather than tangled from an org file --
;; matching Elpaca's own reference setup. This code has to run using
;; only plain Emacs primitives, before Org is guaranteed usable: our
;; literate loader below depends on org-babel-load-file, which needs
;; Org loaded, which would be circular if Elpaca's own bootstrap were
;; itself something we had to tangle to reach. Keeping it here removes
;; that circularity, and is also why it's never byte- or
;; native-compiled -- see the Local Variables footer at the end of
;; this file.
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; use-package support
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; `compat' is depended on by ~20 packages across the rest of this
;; config (vertico, orderless, doom-modeline, org-modern, magit...).
;; `:wait t' is Elpaca's own documented mechanism for blocking until a
;; package is fully installed/configured before continuing -- the
;; idiomatic replacement for the manual
;; (elpaca compat) + (elpaca-process-queues) workaround from before.
(use-package compat :ensure (:wait t))
;; --- End Elpaca bootstrap ---------------------------------------------

;; Pre-authorize the one `eval' dir-local form used in lisp/.dir-locals.el
;; (auto-tangle-on-save for every literate file under lisp/), so Emacs
;; doesn't prompt for confirmation every time a new file there is opened.
(add-to-list 'safe-local-eval-forms
             '(add-hook 'after-save-hook #'org-babel-tangle nil t))

(defvar my/config-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory holding the split literate config files.")

(defun my/load-literate-config (file)
  "Tangle FILE (an org file under `my/config-dir') if stale, then load it.
Each file tangles to its own same-named .el, independently of the
others -- no #+INCLUDE, no shared tangle target. Always byte-compiles
on (re)tangle, and prefers the .elc on the cached path: with the raw
Elpaca bootstrap now living in this file directly rather than in a
tangled org file, none of the literate files declare and immediately
use a macro within the same file anymore, so there's no longer a
compile-order hazard to special-case around."
  (let* ((org-file (expand-file-name file my/config-dir))
         (el-file  (expand-file-name
                    (concat (file-name-base file) ".el")
                    my/config-dir)))
    (if (and (file-exists-p el-file)
             (file-newer-than-file-p el-file org-file))
        (load (file-name-sans-extension el-file))
      (org-babel-load-file org-file t))))

;; bootstrap.org now only holds core settings (use-package-always-ensure,
;; which-key-mode) -- the raw Elpaca bootstrap itself lives above. Order
;; among these six no longer matters structurally, but bootstrap.org
;; stays first since use-package-always-ensure should be set before
;; anything else declares a use-package form.
(dolist (file '("bootstrap.org"
                "completion.org"
                "editor.org"
                "ui.org"
                "org-config.org"
                "file-management.org"
                "programming.org"))
  (my/load-literate-config file))

;; Elpaca's own docs recommend deferring anything that depends on all
;; packages being truly activated -- including loading of saved
;; customizations -- to `elpaca-after-init-hook' rather than running
;; it as bare top-level code, since package activation can still be
;; in-flight even after this file has finished being read.
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (custom-set-variables
             ;; custom-set-variables was added by Custom.
             ;; If you edit it by hand, you could mess it up, so be careful.
             ;; Your init file should contain only one such instance.
             ;; If there is more than one, they won't work right.
             '(custom-safe-themes
               '("34d84ab5a582eb28e67c3017ab7af0916ed2b34c071ee5dd3b92e679d57413c3"
                 "30b34b5d8b19449406cdbe70dd6aa2d5edb0504df027cd028cbe35faf8353649"
                 "c1ec19bedfe30cc2cef61c72ff8cbd1593857dcbae89f6649a0c80c3d26213e8"
                 "9ec9cb6b3fea5ecc1530eb9d24bce05b26f2e0398dd66a3b5628f560ba4e955c"
                 default)))
            (custom-set-faces
             ;; custom-set-faces was added by Custom.
             ;; If you edit it by hand, you could mess it up, so be careful.
             ;; Your init file should contain only one such instance.
             ;; If there is more than one, they won't work right.
             )))

;;; init.el ends here

;; Local Variables:
;; no-byte-compile: t
;; no-native-compile: t
;; no-update-autoloads: t
;; End:
