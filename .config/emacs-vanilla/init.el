;;; init.el --- Bootstrapper -*- lexical-binding: t; -*-

;; Pre-authorize the one `eval' dir-local form used in lisp/.dir-locals.el
;; (auto-tangle-on-save for every literate file under lisp/), so Emacs
;; doesn't prompt for confirmation every time a new file there is opened.
(add-to-list 'safe-local-eval-forms
             '(add-hook 'after-save-hook #'org-babel-tangle nil t))

(defvar my/config-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory holding the split literate config files.")

(defun my/load-literate-config (file &optional compile)
  "Tangle FILE (an org file under `my/config-dir') if stale, then load it.
Each file tangles to its own same-named .el, independently of the
others -- no #+INCLUDE, no shared tangle target.

When COMPILE is non-nil, byte-compile on (re)tangle, and prefer the
.elc on the cached path too. Pass nil (the default) for files whose
top-level code defines and immediately uses a macro within that same
file -- e.g. Elpaca's bootstrap, which defines the `elpaca' macro and
calls it in the same breath. Byte-compiling that sequence compiles
the call before the macro is known to exist, turning it into a plain
function call and breaking at runtime with `invalid-function'."
  (let* ((org-file (expand-file-name file my/config-dir))
         (el-file  (expand-file-name
                     (concat (file-name-base file) ".el")
                     my/config-dir)))
    (if (and (file-exists-p el-file)
             (file-newer-than-file-p el-file org-file))
        (if compile
            (load (file-name-sans-extension el-file))
          (load-file el-file))
      (org-babel-load-file org-file compile))))

;; bootstrap.org must load first, and never compiled -- see the
;; docstring above.
(my/load-literate-config "bootstrap.org")

;; Everything else can be reordered freely, and is safe to compile:
;; by the time these load, Elpaca and use-package are already fully
;; loaded as real macros, not autoloaded stubs.
(dolist (file '("completion.org"
                 "editor.org"
                 "ui.org"
                 "org-config.org"
                 "file-management.org"
                 "programming.org"))
  (my/load-literate-config file t))

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
 )

;;; init.el ends here
